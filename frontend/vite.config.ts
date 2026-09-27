import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],

  resolve: {
    // Đảm bảo toàn bộ dependency dùng chung một React instance
    dedupe: ['react', 'react-dom'],
  },

  server: {
    watch: {
      // Không để Vite liên tục watch code Wails tự generate
      ignored: ['**/wailsjs/**'],
    },
  },
})