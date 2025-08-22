import { defineConfig, loadEnv } from 'vite';
import vue from '@vitejs/plugin-vue';
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import { resolve } from 'path'
import { createSvgIconsPlugin } from 'vite-plugin-svg-icons'
import fs from 'fs'

// 使用unplugin-vue-components 按需导入的依赖项更新导致页面无限次重载问题
const optimizeDepsElementPlusIncludes = ['element-plus/es'];
fs.readdirSync('node_modules/element-plus/es/components').forEach((dirname) => {
  fs.access(
    `node_modules/element-plus/es/components/${dirname}/style/css.mjs`,
    (err) => {
      if (!err) {
        optimizeDepsElementPlusIncludes.push(
          `element-plus/es/components/${dirname}/style/css`
        );
      }
    }
  )
})

export default defineConfig(({ command, mode }) => {
  // 获取.env文件里定义的环境变量
  const env = loadEnv(mode, process.cwd());
  console.log(mode, command, env); // 变量在命令行里打印出来
  return {
    base: env.VITE_BASE_PREFIX,
    // root: resolve(__dirname, 'src'),
    // publicDir: resolve(__dirname, './public'),
    plugins: [
      vue(),
      AutoImport({
        resolvers: [ElementPlusResolver()],
      }),
      Components({
        resolvers: [ElementPlusResolver({
          importStyle: 'sass'
        })],
      }),
      createSvgIconsPlugin({
        // 指定需要缓存的图标文件夹
        iconDirs: [resolve(process.cwd(), 'src/assets/icon/svg')],
        // 指定symbolId格式
        symbolId: 'icon-[name]',
      })
    ],
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src'),
        '@@': resolve(__dirname, 'canvas')
      },
    },
    server: {
      proxy: {
        '/api': {
          target: env.VITE_BASE_URL,
          changeOrigin: true,
          rewrite: path => path.replace(/^\/api/, ''),
        }
      },
    },
    define: {
      'process.env': {}
    },
    css: {
      preprocessorOptions: {
        // 全局样式引入
        scss: {
          additionalData: '@use "canvas/styles/index.scss" as *;',
          javascriptEnabled: true
        }
      }
    },
    // 构建配置项
    build: {
      chunkSizeWarningLimit: 1500,
      rollupOptions: {
        input: {
          index: resolve(__dirname, 'index.html'),
          canvas: resolve(__dirname, 'canvas.html')
        },
        output: {
          manualChunks (id) {
            if (id.includes('node_modules')) {
              return id
                .toString()
                .split('node_modules/')[1]
                .split('/')[0]
                .toString();
            }
          },
        },
      },
    },
    optimizeDeps: {
      include: optimizeDepsElementPlusIncludes
    }
  }
})
