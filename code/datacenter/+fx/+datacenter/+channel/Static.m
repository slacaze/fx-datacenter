classdef Static < fx.datacenter.channel.mixin.Cached
    
    properties( GetAccess = private, SetAccess = immutable )
        Values_ double
    end
    
    methods( Access = public )
        
        function this = Static( name, units, values )
            this@fx.datacenter.channel.mixin.Cached( name, units );
            validateattributes( values, ...
                {'double'}, {'column'} );
            this.Values_ = values;
            % Garantee the channel starts unstale
            this.getValues();
        end
        
    end
    
    methods( Access = protected )
        
        function values = extractValues( this )
            values = this.Values_;
        end
        
    end
    
end