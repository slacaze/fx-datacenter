classdef Manager < handle
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        ChannelNames
    end
    
    properties( GetAccess = private, SetAccess = private )
        Channels_(1,:) fx.datacenter.channel.mixin.Base = fx.datacenter.channel.mixin.Base.empty( 1, 0 )
        ChannelsDestroyedListeners(1,:) event.listener = event.listener.empty( 1, 0 )
    end
    
    methods
        
        function names = get.ChannelNames( this )
            names = {this.Channels_.Name};
        end
        
    end
    
    methods( Access = public )
        
        function this = Manager()
        end
        
    end
    
    methods( Access = public )
        
        function addChannels( this, channels )
            validateattributes( channels, ...
                {'fx.datacenter.channel.mixin.Base'}, {'row'} );
            % Names must be unique
            validIndex = ~ismember( {channels.Name}, this.ChannelNames );
            ignoredChannels = channels(~validIndex);
            if ~isempty( ignoredChannels )
                warning( ...
                    'DataCenter:InvalidChannels', ...
                    'Some channels already exists, ignoring:\n%s', ...
                    strjoin( {ignoredChannels.Name}, ', ' ) );
            end
            channelsToAdd = channels(validIndex);
            if ~isempty( channelsToAdd )
                this.Channels_ = [ ...
                    this.Channels_, ...
                    channelsToAdd, ...
                    ];
                for channelIndex = 1:numel( channelsToAdd )
                    this.ChannelsDestroyedListeners(end+1) = event.listener( ...
                        channelsToAdd(channelIndex), 'ObjectBeingDestroyed', ...
                        @(~,~) this.removeChannels( channelsToAdd(channelIndex) ) );
                end
            end
        end
        
        function removeChannels( this, channels )
            validateattributes( channels, ...
                {'fx.datacenter.channel.mixin.Base'}, {'row'} );
            % Can only remove channels that exists
            [exist, position] = ismember( channels, this.Channels_ );
            ignoredChannels = channels(~exist);
            if ~isempty( ignoredChannels )
                warning( ...
                    'DataCenter:InvalidChannels', ...
                    'Some channels don''t exist, ignoring:\n%s', ...
                    strjoin( {ignoredChannels.Name}, ', ' ) );
            end
            if any( exist )
                this.Channels_(position(exist)) = [];
                this.ChannelsDestroyedListeners(position(exist)) = [];
            end
        end
        
        function values = getChannelValues( this, channelNames )
            if ischar( channelNames )
                channelNames = {channelNames};
            end
            validateattributes( channelNames, ...
                {'cell'}, {'row'} );
            for channelIndex = 1:numel( channelNames )
                validateattributes( channelNames{channelIndex}, ...
                    {'char'}, {'scalartext'} );
            end
            % Names must be unique
            [exist, position] = ismember( channelNames, this.ChannelNames );
            ignoredChannels = channelNames(~exist);
            if ~isempty( ignoredChannels )
                warning( ...
                    'DataCenter:InvalidChannels', ...
                    'Some channels don''t exist, ignoring:\n%s', ...
                    strjoin( ignoredChannels, ', ' ) );
            end
            values = table( ...
                this.Channels_(position(exist)).Values, ...
                'VariableNames', this.ChannelNames(position(exist)) );
        end
        
    end
    
end