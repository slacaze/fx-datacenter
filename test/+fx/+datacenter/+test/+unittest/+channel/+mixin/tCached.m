classdef tCached < matlab.mock.TestCase
    
    properties
        CacheMock
        CacheBehavior
    end
    
    methods( TestMethodSetup )
        
        function createCachedMock( this )
            [this.CacheMock, this.CacheBehavior] = this.createMock( ...
                ?fx.datacenter.channel.mixin.Cached, ...
                'ConstructorInputs', {'myChannel', 'myUnit'}, ...
                'Strict', true );
        end
        
    end
    
    methods( Test )
        
        function testExtractValueIfStale( this )
            this.assignOutputsWhen( ...
                this.CacheBehavior.getStaleness.withExactInputs, ...
                true );
            this.assignOutputsWhen( ...
                this.CacheBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.CacheMock.Values;
            this.verifyCalled( this.CacheBehavior.extractValues.withExactInputs );
            this.verifyEqual( values, [1;2;3;4;5] );
        end
        
        function testDoesNotExtractValueIfNotStale( this )
            this.assignOutputsWhen( ...
                this.CacheBehavior.getStaleness.withExactInputs, ...
                false );
            this.assignOutputsWhen( ...
                this.CacheBehavior.extractValues.withExactInputs, ...
                [1;2;3;4;5] );
            values = this.CacheMock.Values;
            this.verifyNotCalled( this.CacheBehavior.extractValues.withAnyInputs );
            this.verifyEqual( values, double.empty( 0, 1 ) );
        end
        
    end
    
end