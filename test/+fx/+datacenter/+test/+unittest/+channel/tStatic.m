classdef tStatic < matlab.unittest.TestCase
    
    methods( Test )
        
        function testReadValues( this )
            channel = fx.datacenter.channel.Static( ...
                'myChannel', 'myUnits', [1;2;3;4;5] );
            this.verifyEqual( channel.Values, [1;2;3;4;5] );
        end
        
        function testStartUnstale( this )
            channel = fx.datacenter.channel.Static( ...
                'myChannel', 'myUnits', [1;2;3;4;5] );
            this.verifyEqual( channel.Stale, false );
        end
        
    end
    
end