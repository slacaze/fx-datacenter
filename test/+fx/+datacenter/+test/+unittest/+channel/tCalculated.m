classdef tCalculated < fx.datacenter.test.WithMockedCachedChannels
    
    methods( Test )
        
        function testStartsWithEmptyFormula( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            this.verifyEqual( channel.FormulaString, '[]' )
        end
        
        function testStartStale( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            this.verifyTrue( channel.Stale );
        end
        
        function testErrorsWithoutInputs( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            channel.FormulaString = 'x + y';
            this.verifyError( @() channel.Values, 'MATLAB:UndefinedFunction' );
        end
        
        function testDoesNotErrorsWithTooManyInputs( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            channel.InputChannels = [ ...
                this.FirstCachedMock, ...
                ];
            values = channel.Values;
            this.verifyEmpty( values );
        end
        
        function testCalculate( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            this.assignOutputsWhen( ...
                this.SecondCachedBehavior.extractValues.withExactInputs, ...
                3 * [1;2;3;4;5] );
            channel.InputChannels = [ ...
                this.FirstCachedMock, ...
                this.SecondCachedMock
                ];
            channel.FormulaString = 'y ./ x';
            values = channel.Values;
            this.verifyEqual( values, 3 * ones( 5, 1 ) );
            this.verifyFalse( channel.Stale );
        end
        
        function testStaleness( this )
            channel = fx.datacenter.channel.Calculated( ...
                'z', 'm' );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            this.assignOutputsWhen( ...
                this.SecondCachedBehavior.extractValues.withExactInputs, ...
                3 * [1;2;3;4;5] );
            channel.InputChannels = [ ...
                this.FirstCachedMock, ...
                this.SecondCachedMock
                ];
            channel.FormulaString = 'y ./ x';
            values = channel.Values;
            this.verifyEqual( values, 3 * ones( 5, 1 ) );
            this.verifyFalse( channel.Stale );
            % At this point, we have channels that are not stale
            % Changing anything about the calculated formula should make
            % the channel stale
            channel.FormulaString = 'y - x';
            this.verifyTrue( channel.Stale );
            values = channel.Values;
            this.verifyEqual( values, 2 * [1;2;3;4;5] );
            this.verifyFalse( channel.Stale );
            % Reordering the inputs should not make it stale
            channel.InputChannels = [ ...
                this.SecondCachedMock, ...
                this.FirstCachedMock
                ];
            this.verifyFalse( channel.Stale );
            % But changing the inputs should
            this.assignOutputsWhen( ...
                this.ThirdCachedBehavior.extractValues.withExactInputs, ...
                6 * [1;2;3;4;5] );
            channel.InputChannels = [ ...
                this.FirstCachedMock, ...
                this.ThirdCachedMock
                ];
            this.verifyTrue( channel.Stale );
            values = channel.Values;
            this.verifyEqual( values, 5 * [1;2;3;4;5] );
            this.verifyFalse( channel.Stale );
            % Also, the channel should be stale if any of it's inputs are
            % stale
            this.assignOutputsWhen( ...
                this.ThirdCachedBehavior.extractValues.withExactInputs, ...
                9 * [1;2;3;4;5] );
            this.ThirdCachedMock.Stale = true;
            this.verifyTrue( channel.Stale );
            values = channel.Values;
            this.verifyEqual( values, 8 * [1;2;3;4;5] );
            this.verifyFalse( channel.Stale );
        end
        
    end
    
end