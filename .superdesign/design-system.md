# Cinematic Dark Mode Design System

## Overview

An immersive, theatrical design system using 3D spatial depth, high-contrast typography, and brutalist layout structures to create a cinematic user experience.

## Colors

### Base Palette
- **Background Primary**: `#050505` (Deep black for maximum depth)
- **Card Surface**: `#111111` (Elevated surface)
- **Text Primary**: `#FFFFFF` (Pure white)
- **Text Secondary**: `#999999` (Medium gray)

### Accent Colors
- **Cyan**: `#06B6D4` (Primary accent)
- **Pink**: `#EC4899` (Secondary accent)
- **Purple**: `#7C3AED` (Functional glow)
- **Accent Gradient**: `linear-gradient(to right, #06B6D4, #EC4899)`

### Section-Specific
- **Pricing Background**: `#0B0216` (Deep purple-black)
- **Calculator Container**: `#1A0B2E` (Dark purple)
- **Purple Glow**: `#7C3AED` with `blur(100px)`

### Interactive States
- **Border Glass**: `rgba(255, 255, 255, 0.1)`
- **Card Backdrop**: `rgba(255, 255, 255, 0.05)`
- **Live Indicator**: `#EF4444` (red-500)

## Typography

### Font Family
- **Primary Font**: 'Aspekta' (weights: 300, 500, 700, 900)
- Fallback: system-ui, sans-serif

### Type Scale

#### Hero Headings
- **Size**: `12vw` (viewport-responsive)
- **Weight**: `900` (Black)
- **Tracking**: `tighter` (reduced letter spacing)
- **Transform**: `uppercase`

#### Section Headers
- **Size**: `10vw` (viewport-responsive)
- **Weight**: `900` (Black)
- **Tracking**: `tighter`
- **Transform**: `uppercase`

#### Secondary Labels
- **Weight**: `700` (Bold)
- **Tracking**: `0.2em` (wide spacing)
- **Transform**: `uppercase`

#### Body Text
- **Size**: `1.125rem` (18px)
- **Weight**: `300` (Light)
- **Line Height**: `1.6`

## Spacing

- **Container Max Width**: `90rem` (1440px)
- **Section Padding**: `4rem 2rem` (desktop), `2rem 1rem` (mobile)
- **Card Padding**: `2rem`
- **Navigation Padding**: `1.5rem 2rem`

## Effects

### 3D Transforms
- **Perspective**: `2000px` (MANDATORY for hero container)
- **Transform Style**: `preserve-3d` (for cube wrapper)

### Glassmorphism
- **Backdrop Filter**: `blur(8px)`
- **Border**: `1px solid rgba(255, 255, 255, 0.1)`
- **Background**: `rgba(255, 255, 255, 0.05)`

### Shadows
- **DO NOT use standard box-shadow**
- Use borders and backdrop-blur for depth instead

### Glows
- **Purple Glow**: `0 0 100px #7C3AED` (pricing section)
- **Button Hover**: `0 0 0 4px rgba(124, 58, 237, 0.5)` (range slider thumb)

## Interactions

### Buttons
- **Hover**: `scale(1.02)`
- **Transition**: `0.2s ease`
- **Background**: Cyan-to-pink gradient
- **Border Radius**: `8px`

### Links
- **Transition**: `0.2s duration`
- **Hover**: Color shift to accent gradient

### Images
- **Default**: `grayscale(100%)`
- **Hover**: `grayscale(0%)`
- **Transition**: `0.3s ease`

### Range Slider
- **Track**: `height: 8px`, `background: #374151`
- **Thumb**: `24px diameter`, `solid white`, `shadow: 0 0 0 4px rgba(124, 58, 237, 0.5)`

## Layout Conventions

### Navigation
- **Position**: `fixed` at `top-0`
- **Mix Blend Mode**: `difference` (MANDATORY for visibility)
- **Layout**: Logo (left), Nav Links (center, hidden mobile), CTA Button (right)
- **Live Indicator**: Red pulsing dot next to logo

### Hero Section
- **Height**: `100vh` (full viewport)
- **Background**: Large text at 30% opacity
- **Foreground**: 3D rotating cube (50vh x 50vh)
- **Rotation**: Infinite X-axis animation

### Grid Systems
- **Featured Project**: Full width, aspect-video
- **Project Grid**: 2-column (desktop), 1-column (mobile)
- **Pricing Cards**: 3-column flex (center card scaled 1.05)

### Aspect Ratios
- **Featured**: `aspect-video` (16:9)
- **Sub-projects**: `aspect-4/3`

## Components

### 3D Transform Cube
- **Container**: `perspective: 2000px`
- **Wrapper**: `transform-style: preserve-3d`, dimensions `50vh x 50vh`
- **Faces**: 4 faces (Front, Bottom, Back, Top)
  - Front: `rotateX(0deg) translateZ(30vh)`
  - Bottom: `rotateX(-90deg) translateZ(30vh)`
  - Back: `rotateX(-180deg) translateZ(30vh)`
  - Top: `rotateX(90deg) translateZ(30vh)`
- **Animation**: `rotateX(360deg)` infinite

### macOS Window Controls
- **Dots**: 12px diameter circles
- **Colors**: Red (#EF4444), Yellow (#F59E0B), Green (#10B981)
- **Spacing**: 8px gap
- **Position**: Top-left of featured project

### Glass-morphism Price Calculator
- **Container**: `#1A0B2E` background, `32px` border-radius
- **Input**: Custom range slider (see Interactions)
- **Display**: Large dynamic price text (`$ {value * 125}`)

### Pricing Cards
- **Side Cards**: Glassmorphism style
- **Center Card (Growth)**: Solid white background, dark text, scaled 1.05
- **Border**: `1px solid rgba(255, 255, 255, 0.1)`
- **Padding**: `2rem`

## Special Rules

### MUST DO:
- Apply `perspective: 2000px` to hero container for 3D depth
- Use `mix-blend-difference` on navigation header
- Keep all headings uppercase for cinematic feel
- Use border-white/10 and backdrop-blur instead of shadows
- Maintain 3D transform-style: preserve-3d on cube wrapper

### DO NOT:
- Use standard box-shadow
- Use lowercase for headings
- Apply blend modes to non-navigation elements
- Skip the perspective property on hero

## Responsive Behavior

### Breakpoints
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

### Mobile Adjustments
- Navigation links hidden, hamburger menu
- Hero text reduced to `8vw`
- 2-column grid becomes 1-column
- Cube size reduced to `40vh`
- Padding reduced to `1rem`
