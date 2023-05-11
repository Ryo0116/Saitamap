const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
  Rails: ['@rails/ujs'],
  Turbolinks: ['turbolinks'],
  ActionCable: ['@rails/actioncable'],
  ActiveStorage: ['@rails/activestorage']
}))

module.exports = environment
