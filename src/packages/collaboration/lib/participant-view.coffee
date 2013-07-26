crypto = require 'crypto'
{View} = require 'space-pen'

module.exports =
class ParticipantView extends View
  @content: ->
    @div class: 'collaboration-participant overlay floating large', =>
      @div class: 'video-container', =>
        @video autoplay: true, outlet: 'video'
        @div class: 'actions', =>
          @a href: '#', class: 'remove', type: 'button', outlet: 'removeButton', title: 'Remove this person'
          @a href: '#', class: 'toggle-video', type: 'button', outlet: 'toggleVideoButton', title: 'Toggle video on/off'
          @a href: '#', class: 'toggle-audio', type: 'button', outlet: 'toggleAudioButton', title: 'Toggle audio on/off'
      @div class: 'volume-container lighter', outlet: 'volumeContainer', =>
        @div class: 'volume', outlet: 'volume'

  initialize: (@session, @participant) ->
    @participant.getMediaConnection().getInboundStreamPromise().done (stream) =>
      @video[0].src = URL.createObjectURL(stream)

    @video.click =>
      @toggleClass('large')

    @removeButton.click @onClickRemove
    @toggleVideoButton.click @onClickToggleVideo
    @toggleAudioButton.click @onClickToggleAudio

    map = @session.getClientIdToSiteIdMap()
    @setSiteId(map.get(@participant.clientId))
    map.on 'changed', ({key}={}) =>
      @setSiteId(map.get(@participant.clientId)) if key == @participant.clientId

  setSiteId: (siteId) ->
    return unless siteId
    @volumeContainer.addClass("site-#{siteId}")
    @volume.addClass("site-#{siteId}")

  attach: ->
    rootView.append(this)

  onClickRemove: =>
    false
  onClickToggleVideo: =>
    false
  onClickToggleAudio: =>
    false
