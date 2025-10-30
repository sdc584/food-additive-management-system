module.exports = {
  devServer: {
    port: 8083,
    proxy: {
      '/api': {
        target: 'http://localhost:8082',
        changeOrigin: true
      }
    }
  },
  lintOnSave: false
}

