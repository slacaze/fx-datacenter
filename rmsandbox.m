function rmsandbox()
    if ~isempty( ver( 'fcam' ) )
        fx.fcam.command.rmsandbox();
    else
        thisPath = fileparts( mfilename( 'fullpath' ) );
        rmpath( fullfile(...
            thisPath,...
            'code',...
            'datacenter' ) );
        rmpath( fullfile(...
            thisPath,...
            'test' ) );
    end
end