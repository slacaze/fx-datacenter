classdef Calculated < fx.datacenter.channel.mixin.Cached
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        InputChannels(1,:) fx.datacenter.channel.mixin.Cached
        FormulaString(1,:) char
    end
    
    properties( GetAccess = private, SetAccess = private )
        InputChannels_(1,:) fx.datacenter.channel.mixin.Cached = fx.datacenter.channel.mixin.Cached.empty( 1, 0 )
        FormulaString_(1,:) char = '[]'
        FunctionHandle(1,1) function_handle = str2func( '@() []' )
        LastModified_(1,1) double = NaN
    end
    
    methods
        
        function channels = get.InputChannels( this )
            channels = this.InputChannels_;
        end
        
        function set.InputChannels( this, channels )
            % Abort setting if the inputs are the same
            abortSet = ...
                numel( this.InputChannels_ ) == numel( channels ) && ...
                all( ismember( this.InputChannels_, channels ) );
            if abortSet
                return;
            end
            % Attempt to set
            oldChannels = this.InputChannels_;
            this.InputChannels_ = channels;
            try
                this.updateFunctionHandle();
            catch
                this.InputChannels_ = oldChannels;
            end
        end
        
        function formula = get.FormulaString( this )
            formula = this.FormulaString_;
        end
        
        function set.FormulaString( this, formula )
            oldFormulaString = this.FormulaString_;
            this.FormulaString_ = formula;
            try
                this.updateFunctionHandle();
            catch
                this.FormulaString_ = oldFormulaString;
            end
        end
        
    end
    
    methods( Access = public )
        
        function this = Calculated( name, units )
            this@fx.datacenter.channel.mixin.Cached( name, units );
        end
        
    end
    
    methods( Access = protected )
        
        function staleness = getStaleness( this )
            staleness = ...
                this.LastModified_ > this.CachedStamp || ...
                isnan( this.LastModified_ ) || ...
                isnan( this.CachedStamp ) || ...
                ( ~isempty( this.InputChannels_ ) && any( [this.InputChannels_.Stale] ) );
        end
        
        function values = extractValues( this )
            values = this.FunctionHandle( this.InputChannels_.Values );
        end
        
    end
    
    methods( Access = private )
        
        function updateFunctionHandle( this )
            this.FunctionHandle = str2func( sprintf( ...
                '@(%s) %s', ...
                strjoin( {this.InputChannels_.Name}, ', ' ), ...
                this.FormulaString_ ) );
            this.LastModified_ = now();
        end
        
    end
    
end