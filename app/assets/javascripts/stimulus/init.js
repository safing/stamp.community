/* eslint no-console:0 */

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const controllers = require.context('./controllers', true, /\.js$/)
application.load(definitionsFromContext(controllers))
