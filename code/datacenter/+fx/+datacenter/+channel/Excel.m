classdef Excel < fx.datacenter.channel.mixin.Cached
    
    properties( GetAccess = public, SetAccess = immutable )
        File char
        Sheet char
        Range char
    end
    
    methods( Access = public )
        
        function this = Excel( name, units, file, sheet, range )
            this@fx.datacenter.channel.mixin.Cached( name, units );
            validateattributes( file, ...
                {'char'}, {'scalartext'} );
            validateattributes( sheet, ...
                {'char'}, {'scalartext'} );
            validateattributes( range, ...
                {'char'}, {'scalartext'} );
            this.File = file;
            this.Sheet = sheet;
            this.Range = range;
        end
        
    end
    
    methods( Access = protected )
        
        function staleness = getStaleness( this )
            staleness = isnan( this.CachedStamp );
        end
        
        function values = extractValues( this )
            values = xlsread( this.File, this.Sheet, this.Range );
        end
        
    end
    
end