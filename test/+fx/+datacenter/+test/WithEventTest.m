classdef WithEventTest < matlab.unittest.TestCase
    
    properties( GetAccess = protected, SetAccess = private )
        Listener event.listener = event.listener.empty
        EventName(1,:) char = char.empty
        EventWasFired(1,1) logical = false
        Source = []
        EventData = []
    end
    
    methods( TestClassSetup )
        
        function eventProperties( this )
            this.Listener = event.listener.empty;
            this.EventName = char.empty;
            this.resetEventProperties();
        end
        
    end
    
    methods( Access = protected )
        
        function resetEventProperties( this )
            this.EventWasFired = false;
            this.Source = true;
            this.EventData = [];
        end
        
        function templateCallback( this, source, eventData )
            this.EventWasFired = true;
            this.Source = source;
            this.EventData = eventData;
        end
        
        function listen( this, target, eventName )
            this.Listener = event.listener( target, ...
                eventName, @this.templateCallback );
            this.EventName = eventName;
        end
        
        function verifyNotified( this )
            this.verifyTrue( this.EventWasFired, ...
                sprintf( 'Event "%s" was not fired.', this.EventName ) );
        end
        
        function verifyNotNotified( this )
            this.verifyFalse( this.EventWasFired, ...
                sprintf( 'Event "%s" was not fired.', this.EventName ) );
        end
        
    end
    
end