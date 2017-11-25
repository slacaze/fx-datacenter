classdef( Abstract ) Base < ...
        handle & ...
        matlab.mixin.Heterogeneous
    
    properties( GetAccess = public, SetAccess = immutable )
        Name char
        Units char
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        Values(:,1) double
    end
    
    methods
        
        function values = get.Values( this )
            values = this.getValues();
        end
        
    end
    
    methods( Access = public )
        
        function this = Base( name, units )
            validateattributes( name, ...
                {'char'}, {'scalartext'} );
            validateattributes( units, ...
                {'char'}, {'scalartext'} );
            this.Name = name;
            this.Units = units;
        end
        
    end
    
    methods( Abstract, Access = protected )
        
        values = getValues( this )
        
    end
    
    methods( Sealed )
        
        function varargout = eq( varargin )
            [varargout{1:nargout}] = eq@handle( varargin{:} );
        end
        
    end
    
end