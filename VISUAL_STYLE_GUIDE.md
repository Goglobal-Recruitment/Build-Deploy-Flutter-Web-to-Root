# SkyQuest Flight Booking App - Visual Style Guide

This document defines the visual design system for the SkyQuest Flight Booking application, ensuring consistency across all screens and components.

## Color Palette

### Primary Colors
| Color Name | HEX Code | Usage |
|------------|----------|-------|
| Primary Blue | `#1D6ED6` | Primary actions, highlights, links |
| Secondary Blue | `#0E2D5D` | Headers, navigation, important text |
| Accent Blue | `#ACD4FC` | Backgrounds, subtle highlights |

### Neutral Colors
| Color Name | HEX Code | Usage |
|------------|----------|-------|
| Background Gray | `#F4F6FD` | Main background color |
| Text Dark | `#3B3B3B` | Primary text color |
| Text Light | `#8F8F8F` | Secondary text, labels |
| Border Gray | `#E2E8F0` | Input borders, dividers |

### Status Colors
| Color Name | HEX Code | Usage |
|------------|----------|-------|
| Success Green | `#4CAF50` | Confirmation, success states |
| Warning Orange | `#FF9800` | Warnings, alerts |
| Error Red | `#F44336` | Error messages, validation |

### Implementation in Code
```dart
// lib/utils/app_styles.dart
static Color primaryColor = const Color(0xFF1D6ED6); // Vibrant Blue
static Color secondaryColor = const Color(0xFF0E2D5D); // Deep Navy
static Color textColor = const Color(0xFF3B3B3B); // Charcoal
static Color textLightColor = const Color(0xFF8F8F8F); // Medium Gray
static Color bgColor = const Color(0xFFF4F6FD); // Light Gray
static Color accentColor = const Color(0xFFACD4FC); // Light Sky Blue
static Color successColor = const Color(0xFF4CAF50); // Green
static Color warningColor = const Color(0xFFFF9800); // Orange
static Color errorColor = const Color(0xFFF44336); // Red
```

## Typography

### Font Family
- **Primary**: Default Flutter font stack (Roboto, sans-serif)
- **Monospace**: For booking references and codes

### Text Styles
| Style Name | Size | Weight | Color | Usage |
|------------|------|--------|-------|-------|
| Headline 1 | 26px | Bold | Secondary Blue | Main headers, screen titles |
| Headline 2 | 21px | Bold | Secondary Blue | Section headers |
| Headline 3 | 17px | Medium | Text Dark | Sub-headers, card titles |
| Headline 4 | 14px | Medium | Text Light | Labels, captions, secondary info |
| Body Text | 16px | Medium | Text Dark | Main content text |
| Tabular Numbers | Variable | Medium | Primary Blue | Prices, times |

### Implementation in Code
```dart
// lib/utils/app_styles.dart
static TextStyle headLineStyle1 = TextStyle(
  fontSize: 26, 
  color: secondaryColor,
  fontWeight: FontWeight.bold
);

static TextStyle headLineStyle2 = TextStyle(
  fontSize: 21, 
  color: secondaryColor,
  fontWeight: FontWeight.bold
);

static TextStyle headLineStyle3 = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w500
);

static TextStyle headLineStyle4 = TextStyle(
  fontSize: 14, 
  color: textLightColor,
  fontWeight: FontWeight.w500
);

static TextStyle textStyle = TextStyle(
  fontSize: 16, 
  color: textColor,
  fontWeight: FontWeight.w500
);
```

## Spacing System

### Base Unit
- **Base Unit**: 8px grid system
- **Multiplier**: All spacing values are multiples of 8px

### Common Spacing Values
| Name | Value | Usage |
|------|-------|-------|
| XXS | 4px | Minimal spacing |
| XS | 8px | Icon padding, small gaps |
| S | 16px | Element padding, small sections |
| M | 24px | Section padding, card spacing |
| L | 32px | Screen padding, large sections |
| XL | 40px | Screen headers, major spacing |
| XXL | 48px | Hero sections, large gaps |

### Implementation in Code
```dart
// lib/utils/app_layout.dart
static getHeight(double pixels) {
  double x = getScreenHeight()/pixels;
  return getScreenHeight()/x;
}

static getWidth(double pixels) {
  double x = getScreenWidth()/pixels;
  return getScreenWidth()/x;
}
```

## Component Design

### Cards
- **Border Radius**: 10px
- **Box Shadow**: `0 2px 5px rgba(0,0,0,0.1)`
- **Padding**: 15px
- **Background**: White (`#FFFFFF`)
- **Margin**: 15px between cards

### Buttons
#### Primary Button
- **Background**: Primary Blue (`#1D6ED6`)
- **Text Color**: White (`#FFFFFF`)
- **Border Radius**: 8px
- **Padding**: 18px vertical, 15px horizontal
- **Font**: Bold, 16px

#### Secondary Button
- **Background**: Transparent
- **Border**: 1px solid Primary Blue
- **Text Color**: Primary Blue
- **Border Radius**: 8px
- **Padding**: 18px vertical, 15px horizontal
- **Font**: Bold, 16px

### Input Fields
- **Height**: 50px
- **Border**: 1px solid Border Gray (`#E2E8F0`)
- **Border Radius**: 5px
- **Padding**: 12px horizontal
- **Focus State**: Primary Blue border
- **Error State**: Error Red border

### Badges
- **Border Radius**: 5px
- **Padding**: 5px vertical, 10px horizontal
- **Font**: Bold, 12px
- **Text Color**: White
- **Direct**: Success Green
- **Fastest**: Warning Orange
- **Cheapest**: Primary Blue

## Iconography

### Icon Set
- **Primary**: FluentUI Icons
- **Size**: 24px (standard), 16px (small), 30px (large)
- **Color**: 
  - Active: Primary Blue
  - Inactive: Text Light
  - Success: Success Green
  - Warning: Warning Orange
  - Error: Error Red

### Common Icons
| Function | Icon | Usage |
|----------|------|-------|
| Search | `Icons.search` | Search functionality |
| Flight Takeoff | `Icons.flight_takeoff` | Origin airports |
| Flight Land | `Icons.flight_land` | Destination airports |
| Calendar | `Icons.calendar_today` | Date selection |
| Person | `Icons.person` | Passenger count |
| Download | `Icons.download` | Invoice download |
| Check | `Icons.check_circle` | Success states |
| Close | `Icons.close` | Close screens |

## Layout Patterns

### Screen Layout
```
┌─────────────────────────────────────────┐
│  Header (56px)                         │
│ ┌─────────────────────────────────────┐ │
│ │  Screen Content                     │ │
│ │                                     │ │
│ │  ┌───────────────────────────────┐  │ │
│ │  │  Card/Section                 │  │ │
│ │  └───────────────────────────────┘  │ │
│ │                                     │ │
│ │  ┌───────────────────────────────┐  │ │
│ │  │  Card/Section                 │  │ │
│ │  └───────────────────────────────┘  │ │
│ └─────────────────────────────────────┘ │
│  Bottom Navigation (56px)              │
└─────────────────────────────────────────┘
```

### Card Layout
```
┌─────────────────────────────────────────┐
│  Badge (if applicable)                 │
│ ┌─────────────────────────────────────┐ │
│ │  Card Content                       │ │
│ │                                     │ │
│ │  ┌─────────┐  ┌─────────┐  ┌────────┐│ │
│ │  │ Element │  │ Element │  │ Element││ │
│ │  └─────────┘  └─────────┘  └────────┘│ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Form Layout
```
┌─────────────────────────────────────────┐
│  Section Header                        │
│ ┌─────────────────────────────────────┐ │
│ │  Input Label                        │ │
│ │  [Input Field                    ]  │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │  Input Label                        │ │
│ │  [Input Field                    ]  │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │  [    Primary Action Button      ]  │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Responsive Design

### Breakpoints
- **Mobile**: 0px - 768px
- **Tablet**: 769px - 1024px
- **Desktop**: 1025px+

### Responsive Adjustments
- **Card Width**: 85% on mobile, 70% on tablet, 60% on desktop
- **Font Sizes**: Scale proportionally with screen size
- **Padding**: Increase on larger screens
- **Layout**: Single column on mobile, multi-column on larger screens

## Accessibility

### Color Contrast
- **Text**: Minimum 4.5:1 contrast ratio
- **Interactive Elements**: Minimum 3:1 contrast ratio
- **Focus States**: Visible focus indicators

### Typography
- **Minimum Size**: 14px for body text
- **Line Height**: 1.5 for body text
- **Font Weight**: Avoid thin weights for small text

### Interactive Elements
- **Touch Targets**: Minimum 44px
- **Focus Indicators**: Visible on keyboard navigation
- **ARIA Labels**: Proper labeling for screen readers

## Implementation Examples

### Custom Card Component
```dart
// lib/widgets/custom_card.dart
Container(
  margin: EdgeInsets.all(AppLayout.getWidth(15)),
  padding: EdgeInsets.all(AppLayout.getWidth(15)),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: child,
)
```

### Custom Button Component
```dart
// lib/widgets/custom_button.dart
ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: backgroundColor ?? Styles.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
    ),
  ),
  child: Text(
    text,
    style: TextStyle(
      color: textColor ?? Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### Badge Component
```dart
// lib/widgets/badge_widget.dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppLayout.getWidth(10),
    vertical: AppLayout.getHeight(5),
  ),
  decoration: BoxDecoration(
    color: color ?? Styles.primaryColor,
    borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
  ),
  child: Text(
    text,
    style: TextStyle(
      color: textColor ?? Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

This visual style guide ensures a consistent, professional appearance across all screens of the SkyQuest Flight Booking application, creating a cohesive user experience that matches the quality and feel of the main page.