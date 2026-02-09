# Cinematic Style Landing Page

**Generated**: February 9, 2026  
**Design System**: Cinematic Dark Mode  
**File**: `cinematic-style-landing-page.html`

## Overview

This is an immersive, theatrical landing page design using 3D spatial depth, high-contrast typography, and brutalist layout structures to create a cinematic user experience.

## SuperDesign Project Details

- **Project ID**: `613b5256-a80e-48ab-9a05-b88ba1228204`
- **Draft ID**: `43cc4a53-c696-43e4-9b60-bd1595a5c6cd`
- **Title**: Cine-Core: Theatrical Design Hub
- **Project URL**: https://app.superdesign.dev/teams/1cb4ec92-10c0-4e89-b325-acf16b47ca2c/projects/613b5256-a80e-48ab-9a05-b88ba1228204
- **Node URL**: https://app.superdesign.dev/teams/1cb4ec92-10c0-4e89-b325-acf16b47ca2c/projects/613b5256-a80e-48ab-9a05-b88ba1228204?node=draft-variant-43cc4a53-c696-43e4-9b60-bd1595a5c6cd
- **Preview URL**: https://p.superdesign.dev/draft/43cc4a53-c696-43e4-9b60-bd1595a5c6cd

## Key Features

### 1. Fixed Navigation with Mix Blend Mode
- Fixed header with `mix-blend-difference` for visibility over any background
- Pulsing red "live" indicator dot
- Gradient CTA button (cyan to pink)

### 2. 3D Rolodex Hero (Full Viewport)
- **Perspective**: 2000px on container (CRITICAL for 3D effect)
- **3D Cube**: 50vh x 50vh with 4 rotating faces
- **Transform Style**: preserve-3d on wrapper
- **Animation**: Infinite X-axis rotation (20s duration)
- **Background**: Large "PORTFOLIO" text at 30% opacity

### 3. Case Studies Grid
- Featured project with macOS window controls (red/yellow/green dots)
- 2-column sub-project grid (1-column on mobile)
- Images start grayscale(100%) and transition to color on hover
- Glassmorphism borders

### 4. Pricing Section
- Deep purple-black background (#0B0216)
- Central purple glow effect
- Three-tier card system:
  - Side cards: Glassmorphism with backdrop-blur
  - Center "Growth" card: Solid white, scaled 1.05
- Interactive price calculator with custom range slider

### 5. Editorial Footer
- Massive-scale gradient headline
- Multi-column link sections
- Newsletter signup

## Design System

### Colors
- Background: `#050505` (deep black)
- Card Surface: `#111111`
- Text Primary: `#FFFFFF`
- Text Secondary: `#999999`
- Accent Gradient: `linear-gradient(to right, #06B6D4, #EC4899)`
- Purple Glow: `#7C3AED`

### Typography
- Font: **Aspekta** (weights: 300, 500, 700, 900)
- Hero Headings: 12vw, weight 900, uppercase
- Section Headers: 10vw, weight 900, uppercase
- Body: 1.125rem, weight 300

### Effects
- **NO standard box-shadow** - uses borders and backdrop-blur
- Glassmorphism: backdrop-filter blur(8px) with rgba borders
- 3D transforms with perspective: 2000px
- Image hover: grayscale 100% → 0%
- Button hover: scale(1.02)

## Technical Implementation

### 3D Cube Structure
```css
.hero-perspective {
    perspective: 2000px; /* MANDATORY */
}

.cube-wrapper {
    transform-style: preserve-3d;
    animation: rotateCube 20s linear infinite;
}

.cube-face {
    position: absolute;
    width: 50vh;
    height: 50vh;
}

.face-front  { transform: rotateX(0deg) translateZ(30vh); }
.face-bottom { transform: rotateX(-90deg) translateZ(30vh); }
.face-back   { transform: rotateX(-180deg) translateZ(30vh); }
.face-top    { transform: rotateX(90deg) translateZ(30vh); }
```

### Interactive Calculator
JavaScript-powered range slider that calculates projected revenue:
```javascript
range.addEventListener('input', (e) => {
    const value = e.target.value;
    display.innerText = '$' + (value * 125).toLocaleString();
});
```

## Responsive Behavior

- **Desktop**: Full 3D effects, multi-column layouts
- **Tablet**: 2-column grids maintained
- **Mobile**: Single column, reduced hero text (8vw), simplified nav

## How to Use

1. Open `cinematic-style-landing-page.html` in a modern browser
2. The page uses Tailwind CDN and Iconify for icons
3. All styles are self-contained in the HTML file
4. No build process required - ready to deploy

## Credits

- **Design Agent**: SuperDesign AI
- **Design System**: Cinematic Dark Mode
- **Generated**: Claude Code + SuperDesign CLI
