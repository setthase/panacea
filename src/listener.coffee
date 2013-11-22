# Require dependencies
axon  = require 'axon'
mongo = require 'mongodb'

# Define private variables
db     = null
queue  = []
socket = null

# Incoming messages handler
handler = (message) ->
  # TODO - put message into database
  # TODO - queue messages when database is not ready
  console.log message

# Configure listener
exports.configure = () ->
  # TODO - configure database

# Start listening for incoming messages
exports.listen = (port) ->

  # Don't allow for running this method twice (or more)
  if socket isnt null
    throw new Error "Panacea: socket is already listening"

  # Setup server instance
  socket = axon.socket 'pull'

  socket.format 'json'
  socket.bind port

  # Start listening for incoming messages
  socket.on 'message', handler

  return this

# Stop listening for new messages and close database connection
exports.close = (fn) ->

  # Stop listening for messages
  socket.off 'message', handler
  do socket.close

  # Close connection to database
  do db.close

  # Clear variables references
  db     = null
  socket = null

  # Run callback function
  do fn if typeof fn is "function"

