classdef( Abstract ) Cached < fx.datacenter.channel.mixin.Base
    
    properties( GetAccess = protected, SetAccess = private, Dependent )
        Staleness(1,1) logical
    end
    
    properties( GetAccess = protected, SetAccess = private )
        CachedStamp(1,1) double = NaN
    end
    
    properties( GetAccess = private, SetAccess = private )
        CachedValues(:,1) double = double.empty( 0, 1 )
    end
    
    methods
        
        function staleness = get.Staleness( this )
            staleness = this.getStaleness();
        end
        
    end
    
    methods( Access = public )
        
        function this = Cached( name, units )
            this@fx.datacenter.channel.mixin.Base( name, units );
        end
        
    end
    
    methods( Access = protected )
        
        function values = getValues( this )
            if this.Staleness
                this.CachedValues = this.extractValues();
                this.CachedStamp = now();
            end
            values = this.CachedValues;
        end
        
    end
    
    methods( Abstract, Access = protected )
        
        values = extractValues( this )
        staleness = getStaleness( this )
        
    end
    
end