classdef WithMockedCachedChannels < matlab.mock.TestCase
    
    properties
        FirstCachedMock
        FirstCachedBehavior
        SecondCachedMock
        SecondCachedBehavior
        ThirdCachedMock
        ThirdCachedBehavior
    end
    
    methods( TestMethodSetup )
        
        function createCachedMock( this )
            [this.FirstCachedMock, this.FirstCachedBehavior] = this.createMock( ...
                ?fx.datacenter.channel.mixin.Cached, ...
                'ConstructorInputs', {'x', 'm'}, ...
                'Strict', true );
            [this.SecondCachedMock, this.SecondCachedBehavior] = this.createMock( ...
                ?fx.datacenter.channel.mixin.Cached, ...
                'ConstructorInputs', {'y', 'g'}, ...
                'Strict', true );
            [this.ThirdCachedMock, this.ThirdCachedBehavior] = this.createMock( ...
                ?fx.datacenter.channel.mixin.Cached, ...
                'ConstructorInputs', {'y', 'g'}, ...
                'Strict', true );
        end
        
    end
    
end