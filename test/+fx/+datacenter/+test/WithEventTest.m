classdef WithEventTest < matlab.unittest.TestCase
    
    properties( GetAccess = protected, SetAccess = private )
        Listener event.listener = event.listener.empty
        EventName(1,:) char = char.empty
        EventWasFired(1,1) logical = false
        Source = {}
        EventData = {}
        NumberOfNotified(1,1) double = 0
    end
    
    methods( TestClassSetup )
        
        function eventProperties( this )
            this.Listener = event.listener.empty;
            this.EventName = char.empty;
            this.resetEventProperties();
        end
        
    end
    
    methods( TestClassTeardown )
        
        function deleteListener( this )
            if ~isempty( this.Listener ) && isvalid( this.Listener )
                delete( this.Listener );
            end
        end
        
    end
    
    methods( Access = protected )
        
        function resetEventProperties( this )
            this.EventWasFired = false;
            this.Source = {};
            this.EventData = {};
            this.NumberOfNotified = 0;
        end
        
        function templateCallback( this, source, eventData )
            this.EventWasFired = true;
            this.Source{end+1} = source;
            this.EventData{end+1} = eventData;
            this.NumberOfNotified = this.NumberOfNotified + 1;
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
                sprintf( 'Event "%s" should have not been fired.', this.EventName ) );
        end
        
    end
    
end