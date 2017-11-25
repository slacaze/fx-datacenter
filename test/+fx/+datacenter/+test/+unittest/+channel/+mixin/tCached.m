classdef tCached < fx.datacenter.test.WithMockedCachedChannels
    
    methods( Test )
        
        function testExtractValueIfStale( this )
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.getStaleness.withExactInputs, ...
                true );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.FirstCachedMock.Values;
            this.verifyCalled( this.FirstCachedBehavior.extractValues.withExactInputs );
            this.verifyEqual( values, [1;2;3;4;5] );
        end
        
        function testDoesNotExtractValueIfNotStale( this )
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.getStaleness.withExactInputs, ...
                false );
            this.assignOutputsWhen( ...
                this.FirstCachedBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.FirstCachedMock.Values;
            this.verifyNotCalled( this.FirstCachedBehavior.extractValues.withAnyInputs );
            this.verifyEqual( values, double.empty( 0, 1 ) );
        end
        
    end
    
end