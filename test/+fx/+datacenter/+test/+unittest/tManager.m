classdef tManager < fx.datacenter.test.WithMockedCachedChannels
    
    methods( Test )
        
        function testInitialState( this )
            manager = fx.datacenter.Manager();
            this.verifyEmpty( manager.ChannelNames );
        end
        
        function testAddChannels( this )
            manager = fx.datacenter.Manager();
            manager.addChannels( this.FirstCachedMock );
            this.verifyEqual( manager.ChannelNames, {'x'} );
            manager.addChannels( this.SecondCachedMock );
            this.verifyEqual( manager.ChannelNames, {'x', 'y'} );
            this.verifyWarning( ...
                @() manager.addChannels( this.ThirdCachedMock ), ...
                'DataCenter:InvalidChannels' );
        end
        
        function testRemoveChannels( this )
            manager = fx.datacenter.Manager();
            manager.addChannels( [ ...
                this.FirstCachedMock, ...
                this.SecondCachedMock, ...
                ] );
            this.verifyEqual( manager.ChannelNames, {'x', 'y'} );
            this.verifyWarning( ...
                @() manager.removeChannels( this.ThirdCachedMock ), ...
                'DataCenter:InvalidChannels' );
            manager.removeChannels( this.SecondCachedMock );
            this.verifyEqual( manager.ChannelNames, {'x'} );
            manager.removeChannels( this.FirstCachedMock );
            this.verifyEmpty( manager.ChannelNames );
        end
        
        function testGetValues( this )
            manager = fx.datacenter.Manager();
            manager.addChannels( [ ...
                this.FirstCachedMock, ...
                this.SecondCachedMock, ...
                ] );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.getStaleness.withExactInputs, ...
                true );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            this.assignOutputsWhen( ...
                this.SecondCachedBehavior.getStaleness.withExactInputs, ...
                true );
            this.assignOutputsWhen( ...
                this.SecondCachedBehavior.extractValues.withExactInputs, ...
                2 * [1;2;3;4;5] );
            values = manager.getChannelValues( {'x', 'y'} );
            expectedValues = table( ...
                [1;2;3;4;5], ...
                2 * [1;2;3;4;5], ...
                'VariableNames', {'x', 'y'} );
            this.verifyEqual( values, expectedValues );
        end
        
        function testChannelIsRemovedOnDestroyed( this )
            channel = fx.datacenter.channel.Static( ...
                'x', 'm', [1;2;3;4;5] );
            manager = fx.datacenter.Manager();
            manager.addChannels( channel );
            this.verifyEqual( manager.ChannelNames, {'x'} );
            delete( channel );
            this.verifyEmpty( manager.ChannelNames );
        end
        
    end
    
end