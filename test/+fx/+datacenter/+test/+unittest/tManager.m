classdef tManager < ...
        fx.datacenter.test.WithMockedCachedChannels & ...
        fx.datacenter.test.WithEventTest
    
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
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
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
        
        function testNotifiedWhenChannelListChanged( this )
            manager = fx.datacenter.Manager();
            this.listen( manager, 'ChannelListChanged' );
            this.resetEventProperties();
            manager.addChannels( this.FirstCachedMock );
            this.verifyNotified();
            this.resetEventProperties();
            manager.addChannels( this.SecondCachedMock );
            this.verifyNotified();
            this.resetEventProperties();
            manager.removeChannels( [ ...
                this.FirstCachedMock, ...
                this.SecondCachedMock, ...
                ] );
            this.verifyNotified();
        end
        
        function testNotfiedWhenChannelValuesChanged( this )
            manager = fx.datacenter.Manager();
            this.listen( manager, 'ChannelValuesChanged' );
            manager.addChannels( this.FirstCachedMock );
            this.verifyNotNotified();
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.FirstCachedMock.Values;
            this.verifyNotNotified();
            this.verifyEqual( values, [1;2;3;4;5] );
            this.FirstCachedMock.Stale = true;
            this.verifyNotified();
        end
        
        function testNotifyWholeChain( this )
            manager = fx.datacenter.Manager();
            this.listen( manager, 'ChannelValuesChanged' );
            channel = fx.datacenter.channel.Calculated( ...
                'x2', 'm' );
            manager.addChannels( channel );
            manager.addChannels( this.FirstCachedMock );
            channel.InputChannels = this.FirstCachedMock;
            channel.FormulaString = 'x .^ 2';
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = channel.Values;
            this.resetEventProperties();
            this.verifyEqual( values, [1;2;3;4;5] .^ 2 );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                2 * [1;2;3;4;5] );
            this.FirstCachedMock.Stale = true;
            this.verifyNotified();
            this.verifyEqual( this.NumberOfNotified, 2 );
            this.verifyEqual( this.EventData{2}.ChannelNames, {'x'} );
            this.verifyEqual( this.EventData{1}.ChannelNames, {'x2'} );
            values = channel.Values;
            this.verifyEqual( values, ( 2 * [1;2;3;4;5] ) .^ 2 );
        end
        
    end
    
end