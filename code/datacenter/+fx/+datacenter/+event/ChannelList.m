classdef ChannelList < event.EventData
    
    properties( GetAccess = public, SetAccess = immutable )
        Channels
        ChannelNames
    end
    
    methods
        
        function this = ChannelList( channels )
            this.Channels = channels;
            this.ChannelNames = {channels.Name};
        end
        
    end
    
end