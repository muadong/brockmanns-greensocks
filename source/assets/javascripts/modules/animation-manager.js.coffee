class brocksock.AnimationManager

  constructor: (@el) ->

    @$el = $(@el)

    @animationCache = {}
    for k,v of brocksock.animation
      @animationCache[k] = 
        animation: v.animation() # execute the functor to get a Timeline
        xCoord: v.xCoord
        bgClass: v.bgClass

    @currentAnimation = @animationCache['animation1'].animation

    brocksock.utils.pubsub.subscribe 'scene-change', @updateAnimation

    $('.replay', @$el).click => @replay()
    $('.doubleReverse', @$el).click => @doubleReverse()
    $('.reverse', @$el).click => @reverse()
    $('.pause', @$el).click => @pause()
    $('.stop', @$el).click => @stop()
    $('.play', @$el).click => @play()
    $('.doublePlay', @$el).click => @doublePlay()

  start: =>
    timeline = new TimelineLite()
    timeline.set(".triangle", {scale: 0, opacity: 0} )
    timeline.add "start", "+=1"
    timeline.to('.triangle', 3, { scale: 1, opacity: 1, rotationX: 330 } )
    timeline.set(".triangle", {rotationX: -30} )
    timeline.add ( => @play() )

  updateAnimation: (e, animationName) =>

    @stop()
    animationObj = @animationCache[animationName]
    @currentAnimation = animationObj.animation

    tl = new TimelineLite()
    tl.to(".triangle", 2, { rotationX: animationObj.xCoord })
    tl.to('body', 2, { className: animationObj.bgClass }, 0)
    tl.call( => @play() )

  replay: =>
    @currentAnimation.timeScale(1)
    @currentAnimation.play(0)

  doubleReverse: =>
    @currentAnimation.timeScale(4)
    if(@currentAnimation.progress() == 0)
      @currentAnimation.reverse(0)
    else
      @currentAnimation.reverse()

  reverse: =>
    @currentAnimation.timeScale(1)
    if(@currentAnimation.progress() == 0)
      @currentAnimation.reverse(0)
    else
      @currentAnimation.reverse()

  pause: =>
    @currentAnimation.pause()

  stop: =>
    @currentAnimation.pause(0)

  play: =>
    @currentAnimation.timeScale(1)
    if(@currentAnimation.progress() == 1)
      @currentAnimation.play(0)
    else
      @currentAnimation.play()

  doublePlay: =>
    @currentAnimation.timeScale(4)
    if(@currentAnimation.progress() == 1)
      @currentAnimation.play(0)
    else
      @currentAnimation.play()