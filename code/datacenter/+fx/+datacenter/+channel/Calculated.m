classdef Calculated < fx.datacenter.channel.mixin.Cached
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        InputChannels(1,:) fx.datacenter.channel.mixin.Cached
        FormulaString(1,:) char
    end
    
    properties( GetAccess = private, SetAccess = private )
        InputChannels_(1,:) fx.datacenter.channel.mixin.Cached = fx.datacenter.channel.mixin.Cached.empty( 1, 0 )
        FormulaString_(1,:) char = '[]'
        FunctionHandle(1,1) function_handle = str2func( '@() []' )
    end
    
    properties( GetAccess = private, SetAccess = private )
        InputChangedListeners(1,:) event.listener = event.listener.empty( 1, 0 )
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
            oldListeners = this.InputChangedListeners;
            this.InputChannels_ = channels;
            if isempty( channels )
                this.InputChangedListeners = event.listener.empty( 1, 0 );
            else
                this.InputChangedListeners = event.listener( this.InputChannels_, ...
                    'ChannelValueChanged', @this.onInputBecameStaled );
            end
            try
                this.updateFunctionHandle();
            catch
                this.InputChannels_ = oldChannels;
                this.InputChangedListeners = oldListeners;
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
            this.Stale = true;
        end
        
        function onInputBecameStaled( this, ~, ~ )
            this.Stale = true;
        end
        
    end
    
end