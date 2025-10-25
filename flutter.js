// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

if (!_flutter) {
  var _flutter = {};
}
_flutter.loader = null;

(function () {
  "use strict";

  const baseUri = ensureTrailingSlash(getBaseURI());

  function getBaseURI() {
    const base = document.querySelector("base");
    return (base && base.href) || "";
  }

  function ensureTrailingSlash(uri) {
    if (uri.slice(-1) !== "/") {
      return uri + "/";
    }
    return uri;
  }

  /**
   * Wraps `promise` in a timeout of the given `duration` in ms.
   *
   * Resolves/rejects with whatever the original `promises` does, or rejects
   * if `promise` takes longer to complete than `duration`. In that case,
   * `debugName` is used to compose a legible error message.
   *
   * If `duration` is < 0, the original `promise` is returned unchanged.
   * @param {Promise} promise
   * @param {number} duration
   * @param {string} debugName
   * @returns {Promise} a wrapped promise.
   */
  async function timeout(promise, duration, debugName) {
    if (duration < 0) {
      return promise;
    }
    return Promise.race([
      promise,
      new Promise((_, reject) => {
        setTimeout(() => {
          reject(
            new Error(
              `${debugName} took more than ${duration}ms to resolve. Moving on.`,
              {
                cause: timeout,
              }
            )
          );
        }, duration);
      }),
    ]);
  }

  /**
   * Handles the creation of a TrustedTypes `policy` that validates URLs based
   * on an (optional) incoming array of RegExes.
   */
  class FlutterTrustedTypesPolicy {
    /**
     * Constructs the policy.
     * @param {[RegExp]} validPatterns the patterns to test URLs
     * @param {String} policyName the policy name (optional)
     */
    constructor(validPatterns, policyName = "flutter-js") {
      const patterns = validPatterns || [
        /\.dart\.js$/,
        /^flutter_service_worker.js$/
      ];
      if (window.trustedTypes) {
        this.policy = trustedTypes.createPolicy(policyName, {
          createScriptURL: function(url) {
            const parsed = new URL(url, window.location);
            const file = parsed.pathname.split("/").pop();
            const matches = patterns.some((pattern) => pattern.test(file));
            if (matches) {
              return parsed.toString();
            }
            console.error(
              "URL rejected by TrustedTypes policy",
              policyName, ":", url, "(download prevented)");
          }
        });
      }
    }

    /**
     * Returns the URL for the script after validating it with TrustedTypes.
     * @param {String} url the script URL
     * @returns {String} the URL to load the script from
     */
    createScriptURL(url) {
      if (this.policy) {
        return this.policy.createScriptURL(url);
      } else {
        return url;
      }
    }
  }

  /**
   * Handles loading/reloading Flutter's service worker, if configured.
   *
   * @see: https://developers.google.com/web/fundamentals/primers/service-workers
   */
  class FlutterServiceWorkerLoader {
    /**
     * Injects a TrustedTypesPolicy (or undefined if the feature is not supported).
     * @param {TrustedTypesPolicy | undefined} policy
     */
    setTrustedTypesPolicy(policy) {
      this.trustedTypesPolicy = policy;
    }

    /**
     * Returns a Promise that resolves when the latest Flutter service worker,
     * configured by `settings` has been loaded and activated.
     *
     * Otherwise, the promise is rejected with an error message.
     * @param {*} settings Service worker settings
     * @returns {Promise} that resolves when the latest serviceWorker is ready.
     */
    loadServiceWorker(settings) {
      if (settings == null) {
        // In the future, settings = null -> uninstall service worker?
        console.debug("Null serviceWorker configuration. Skipping.");
        return Promise.resolve();
      }
      if (!("serviceWorker" in navigator)) {
        let errorMessage = "Service Worker API unavailable.";
        if (!window.isSecureContext) {
          errorMessage += "\nThe current context is NOT secure."
          errorMessage += "\nRead more: https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts";
        }
        return Promise.reject(
          new Error(errorMessage)
        );
      }
      const {
        serviceWorkerVersion,
        serviceWorkerUrl = `${baseUri}flutter_service_worker.js?v=${serviceWorkerVersion}`,
        timeoutMillis = 4000,
      } = settings;

      // Apply the TrustedTypes policy, if present.
      let url = serviceWorkerUrl;
      if (this.trustedTypesPolicy != null) {
        url = this.trustedTypesPolicy.createScriptURL(url);
      }

      const serviceWorkerActivation = navigator.serviceWorker
        .register(url)
        .then(this._getNewServiceWorker)
        .then(this._waitForServiceWorkerActivation)
        .catch((error) => {
          let message = "Failed to register or activate service worker: " + error.message;
          if (error.name === "SecurityError") {
            message += "\nThe current context is NOT secure.";
            message += "\nRead more: https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts";
          }
          throw new Error(message);
        });

      return timeout(
        serviceWorkerActivation,
        timeoutMillis,
        "prepareServiceWorker"
      );
    }

    /**
     * Returns the latest service worker for the given `serviceWorkerRegistrationPromise`.
     *
     * This might return the current service worker, if there's no new service worker
     * awaiting to be installed/updated.
     *
     * @param {Promise<ServiceWorkerRegistration>} serviceWorkerRegistrationPromise
     * @returns {Promise<ServiceWorker>}
     */
    async _getNewServiceWorker(serviceWorkerRegistrationPromise) {
      const reg = await serviceWorkerRegistrationPromise;

      if (!reg.active && (reg.installing || reg.waiting)) {
        // No active web worker and we have installed or are installing
        // one for the first time. Simply wait for it to activate.
        console.debug("Installing/Activating first service worker.");
        return reg.installing || reg.waiting;
      } else if (!reg.active.scriptURL.endsWith(serviceWorkerVersion)) {
        // When the app updates the serviceWorkerVersion changes, so we
        // need to ask the service worker to update.
        return reg.update().then((newReg) => {
          return newReg.installing || newReg.waiting || newReg.active;
        });
      } else {
        // It's the active service worker, we're good.
        return reg.active;
      }
    }

    /**
     * Returns a Promise that resolves when the `latestServiceWorker` finishes its
     * activation.
     *
     * @param {Promise<ServiceWorker>} latestServiceWorkerPromise
     * @returns {Promise<void>}
     */
    async _waitForServiceWorkerActivation(latestServiceWorkerPromise) {
      const serviceWorker = await latestServiceWorkerPromise;

      if (serviceWorker.state == "activated") {
        console.debug("Service worker already activated.");
        return;
      }

      return new Promise((resolve, _) => {
        serviceWorker.addEventListener("statechange", () => {
          if (serviceWorker.state == "activated") {
            console.debug("Activated new service worker.");
            resolve();
          }
        });
      });
    }
  }

  /**
   * Handles injecting the main Flutter web entrypoint (main.dart.js), and notifying
   * the user when Flutter is ready, through `didCreateEngineInitializer`.
   *
   * @see https://docs.flutter.dev/development/platform-integration/web/initialization
   */
  class FlutterEntrypointLoader {
    /**
     * Creates a FlutterEntrypointLoader.
     */
    constructor() {
      // Watchdog to prevent injecting the main entrypoint multiple times.
      this._scriptLoaded = false;
    }

    /**
     * Injects a TrustedTypesPolicy (or undefined if the feature is not supported).
     * @param {TrustedTypesPolicy | undefined} policy
     */
    setTrustedTypesPolicy(policy) {
      this.trustedTypesPolicy = policy;
    }

    /**
     * Loads flutter main entrypoint, specified by `entrypointUrl`, and calls a
     * user-specified `onEntrypointLoaded` callback with an EngineInitializer
     * object when it's done.
     *
     * @param {string} entrypointUrl the URL of the script that will initialize
     *                 Flutter.
     * @param {Function} onEntrypointLoaded a callback that will be called when
     *                   Flutter web expects you to create an instance of
     *                   `FlutterEngine`.
     * @returns {Promise | undefined} that will eventually resolve with an
     *                               EngineInitializer, or will be rejected with
     *                               any error caused by the script. Returns
     *                               undefined when an `onEntrypointLoaded` is
     *                               provided.
     */
    async loadEntrypoint(entrypointUrl, onEntrypointLoaded) {
      const error = this._checkEntrypointConfiguration(onEntrypointLoaded);
      if (error) {
        return Promise.reject(error);
      }

      if (this._scriptLoaded) {
        return Promise.reject(
          new Error("The Flutter web entrypoint has already been loaded.")
        );
      }

      // Apply the TrustedTypes policy, if present.
      let url = entrypointUrl || `${baseUri}main.dart.js`;
      if (this.trustedTypesPolicy != null) {
        url = this.trustedTypesPolicy.createScriptURL(url);
      }

      this._scriptLoaded = true;
      const scriptTag = this._createScriptTag(url);
      const scriptPromise = this._waitForEntrypointToLoad(scriptTag);

      document.body.append(scriptTag);

      // If a user supplies an onEntrypointLoaded function, call it.
      if (typeof onEntrypointLoaded === "function") {
        scriptPromise.then((engineInitializer) => {
          onEntrypointLoaded(engineInitializer);
        });
        return undefined;
      }

      // Otherwise, return the promise.
      return scriptPromise;
    }

    /**
     * Returns `true` if the user has provided an `onEntrypointLoaded` callback,
     * and `false` otherwise.
     *
     * If `false` is returned, it doesn't guarantee that the callback will never
     * be supplied in the future.
     *
     * @param {Function} onEntrypointLoaded a user-specified callback function
     * @returns {boolean} whether or not a callback was supplied
     */
    _checkEntrypointConfiguration(onEntrypointLoaded) {
      if (typeof onEntrypointLoaded !== "function") {
        return new Error("Flutter loader `onEntrypointLoaded` callback must be a function.");
      }
    }

    /**
     * Creates a script tag that loads the Flutter entrypoint.
     *
     * @param {string} url the URL of the script to load
     * @returns {HTMLScriptElement} the script tag
     */
    _createScriptTag(url) {
      const scriptTag = document.createElement("script");
      scriptTag.type = "application/javascript";
      scriptTag.src = url;
      scriptTag.async = true;
      scriptTag.defer = true;
      return scriptTag;
    }

    /**
     * Returns a Promise that resolves when the Flutter entrypoint has been
     * loaded and calls the `didCreateEngineInitializer` callback.
     *
     * @param {HTMLScriptElement} scriptTag the script tag that loads the Flutter
     *                                      entrypoint
     * @returns {Promise<EngineInitializer>} a Promise that resolves when the
     *                                       entrypoint has loaded
     */
    _waitForEntrypointToLoad(scriptTag) {
      return new Promise((resolve, reject) => {
        scriptTag.addEventListener("error", (error) => {
          reject(new Error(`Failed to load script at URL "${scriptTag.src}".`));
        });

        scriptTag.addEventListener("load", () => {
          // Remove the script tag from the DOM after it has loaded.
          scriptTag.remove();

          // Wait for Flutter to call `didCreateEngineInitializer` callback.
          const timeoutId = setTimeout(() => {
            reject(new Error("Failed to initialize Flutter within 30 seconds."));
          }, 30000);

          window.didCreateEngineInitializer = (engineInitializer) => {
            clearTimeout(timeoutId);
            resolve(engineInitializer);
          };
        });
      });
    }
  }

  /**
   * The public interface of _flutter.loader. Exposes two methods:
   * * loadEntrypoint (which is required for using the Flutter web engine)
   * * loadServiceWorker (which is used to register a service worker)
   */
  class FlutterLoader {
    /**
     * Initializes the Flutter web app.
     * @param {*} options {@see FlutterEntrypointLoader.loadEntrypoint} and
     * {@see FlutterServiceWorkerLoader.loadServiceWorker} for available options.
     * @returns {Promise} a Promise that resolves when the Flutter app is ready.
     */
    async initialize(options) {
      const { serviceWorker, ...entrypoint } = options || {};

      // A Trusted Types policy that validates URLs.
      const flutterTrustedTypesPolicy = new FlutterTrustedTypesPolicy();

      // The FlutterServiceWorkerLoader instance.
      const serviceWorkerLoader = new FlutterServiceWorkerLoader();
      serviceWorkerLoader.setTrustedTypesPolicy(flutterTrustedTypesPolicy.policy);
      await serviceWorkerLoader.loadServiceWorker(serviceWorker);

      // The FlutterEntrypointLoader instance.
      const entrypointLoader = new FlutterEntrypointLoader();
      entrypointLoader.setTrustedTypesPolicy(flutterTrustedTypesPolicy.policy);
      await entrypointLoader.loadEntrypoint(entrypoint);

      // Remove our loading div when the app is ready.
      const loadingDiv = document.querySelector("#loading");
      if (loadingDiv) {
        loadingDiv.remove();
      }
    }
  }

  _flutter.loader = new FlutterLoader();
})();