const Elm = require('vite-plugin-elm')

export default {
  root: 'src',
  build: {
    outDir: '../dist'
  },
  plugins: [
    Elm.plugin({
      debug: process.env.NODE_ENV !== 'production'
    })
  ]
}