classdef tCached < fx.datacenter.test.WithMockedCachedChannels
    
    methods( Test )
        
        function testExtractValueIfStale( this )
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.FirstCachedMock.Values;
            this.verifyCalled( this.FirstCachedBehavior.extractValues.withExactInputs );
            this.verifyEqual( values, [1;2;3;4;5] );
        end
        
        function testDoesNotExtractValueIfNotStale( this )
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.FirstCachedMock.Values;
            this.verifyCalled( this.FirstCachedBehavior.extractValues.withExactInputs );
            this.verifyEqual( values, [1;2;3;4;5] );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                2 * [1;2;3;4;5] );
            this.verifyEqual( values, [1;2;3;4;5] );
        end
        
    end
    
end