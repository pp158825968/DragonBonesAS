package dragonBones.animation
{
	import dragonBones.core.BaseObject;
	import dragonBones.core.dragonBones_internal;
	import dragonBones.events.EventObject;
	import dragonBones.events.IEventDispatcher;
	
	use namespace dragonBones_internal;
	
	/**
	 * @private
	 */
	public final class AnimationTimelineState extends TimelineState
	{
		private var _isStarted:Boolean;
		
		public function AnimationTimelineState()
		{
			super(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onClear():void
		{
			_isStarted = false;
		}
		
		override public function update(time:Number):void
		{
			const prevPlayTimes:uint = this._currentPlayTimes;
			
			super.update(time);
			
			const eventDispatcher:IEventDispatcher = this._armature.display;
			var eventObject:EventObject = null;
			
			if (!_isStarted && this._currentTime > 0)
			{
				_isStarted = true;
				
				if (eventDispatcher.hasEvent(EventObject.START))
				{
					eventObject = BaseObject.borrowObject(EventObject) as EventObject;
					eventObject.animationState = this._animationState;
					this._armature._bufferEvent(eventObject, EventObject.START);
				}
			}
			
			if (prevPlayTimes != this._currentPlayTimes)
			{
				//const eventType:String = _isCompleted? EventObject.COMPLETE: EventObject.LOOP_COMPLETE;
				var eventType:String = null;
				if (_isCompleted)
				{
					eventType = EventObject.COMPLETE;
				}
				else
				{
					eventType = EventObject.LOOP_COMPLETE;
				}
				
				if (eventDispatcher.hasEvent(eventType))
				{
					eventObject = BaseObject.borrowObject(EventObject) as EventObject;
					eventObject.animationState = this._animationState;
					this._armature._bufferEvent(eventObject, eventType);
				}
			}
		}
	}
}