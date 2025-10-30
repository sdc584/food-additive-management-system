<template>
  <div class="custom-logo">
    <svg width="100%" height="100%" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <!-- 主背景渐变 -->
        <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#764ba2;stop-opacity:1" />
        </linearGradient>

        <!-- 图标渐变 -->
        <linearGradient id="iconGradient1" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.95" />
          <stop offset="100%" style="stop-color:#e0e7ff;stop-opacity:0.9" />
        </linearGradient>

        <linearGradient id="iconGradient2" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" style="stop-color:#a5f3fc;stop-opacity:0.9" />
          <stop offset="100%" style="stop-color:#67e8f9;stop-opacity:0.95" />
        </linearGradient>

        <!-- 光泽效果 -->
        <radialGradient id="gloss" cx="30%" cy="30%">
          <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.3" />
          <stop offset="100%" style="stop-color:#ffffff;stop-opacity:0" />
        </radialGradient>
      </defs>

      <!-- 背景 -->
      <rect x="0" y="0" width="80" height="80" rx="18" fill="url(#bgGradient)"/>

      <!-- 光泽层 -->
      <ellipse cx="40" cy="25" rx="35" ry="20" fill="url(#gloss)"/>

      <!-- 主图标 - 分子结构风格 -->
      <g transform="translate(40, 40)">
        <!-- 中心圆 -->
        <circle cx="0" cy="0" r="8" fill="url(#iconGradient1)" stroke="#fff" stroke-width="2"/>

        <!-- 周围的原子 -->
        <g opacity="0.95">
          <!-- 上 -->
          <line x1="0" y1="-8" x2="0" y2="-18" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
          <circle cx="0" cy="-22" r="5" fill="url(#iconGradient2)" stroke="#fff" stroke-width="1.5"/>

          <!-- 右上 -->
          <line x1="6" y1="-6" x2="13" y2="-13" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
          <circle cx="16" cy="-16" r="5" fill="url(#iconGradient2)" stroke="#fff" stroke-width="1.5"/>

          <!-- 右下 -->
          <line x1="6" y1="6" x2="13" y2="13" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
          <circle cx="16" cy="16" r="5" fill="url(#iconGradient2)" stroke="#fff" stroke-width="1.5"/>

          <!-- 左下 -->
          <line x1="-6" y1="6" x2="-13" y2="13" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
          <circle cx="-16" cy="16" r="5" fill="url(#iconGradient2)" stroke="#fff" stroke-width="1.5"/>

          <!-- 左上 -->
          <line x1="-6" y1="-6" x2="-13" y2="-13" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
          <circle cx="-16" cy="-16" r="5" fill="url(#iconGradient2)" stroke="#fff" stroke-width="1.5"/>
        </g>

        <!-- 中心高光 -->
        <circle cx="0" cy="0" r="3" fill="#fff" opacity="0.6"/>
      </g>
    </svg>
  </div>
</template>

<script>
export default {
  name: 'CustomLogo'
}
</script>

<style scoped>
.custom-logo {
  display: inline-block;
}

.custom-logo svg {
  display: block;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.15));
}
</style>

