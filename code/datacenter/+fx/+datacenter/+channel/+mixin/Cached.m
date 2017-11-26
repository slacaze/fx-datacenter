classdef( Abstract ) Cached < ...
        handle & ...
        matlab.mixin.Heterogeneous
    
    properties( GetAccess = public, SetAccess = immutable )
        Name char
        Units char
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        Values(:,1) double
        Stale(1,1) logical
    end
    
    properties( GetAccess = protected, SetAccess = private )
        CachedStamp(1,1) double = NaN
    end
    
    properties( GetAccess = private, SetAccess = private )
        CachedValues(:,1) double = double.empty( 0, 1 )
    end
    
    methods
        
        function values = get.Values( this )
            values = this.getValues();
        end
        
        function staleness = get.Stale( this )
            staleness = this.getStaleness();
        end
        
    end
    
    methods( Access = public )
        
        function this = Cached( name, units )
            validateattributes( name, ...
                {'char'}, {'scalartext'} );
            validateattributes( units, ...
                {'char'}, {'scalartext'} );
            this.Name = name;
            this.Units = units;
        end
        
    end
    
    methods( Access = protected )
        
        function values = getValues( this )
            if this.Stale
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
    
    methods( Sealed )
        
        function varargout = eq( varargin )
            [varargout{1:nargout}] = eq@handle( varargin{:} );
        end
        
    end
    
end