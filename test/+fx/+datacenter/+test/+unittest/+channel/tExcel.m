classdef tExcel < matlab.unittest.TestCase
    
    methods( Test )
        
        function testReadValues( this )
            file = fullfile( ...
                datacentertestroot, ...
                'sample', ...
                'sample.xlsx' );
            sheet = 'test';
            range = 'A3:A7';
            channel = fx.datacenter.channel.Excel( ...
                'myChannel', 'myUnits', file, sheet, range );
            this.verifyEqual( channel.Values, [1;2;3;4;5] );
        end
        
        function testReadOnlyOnce( this )
            file = fullfile( ...
                datacentertestroot, ...
                'sample', ...
                'sample.xlsx' );
            newFile = sprintf( '%s.xlsx', tempname );
            copyfile( file, newFile );
            sheet = 'test';
            range = 'A3:A7';
            channel = fx.datacenter.channel.Excel( ...
                'myChannel', 'myUnits', newFile, sheet, range );
            this.verifyEqual( channel.Values, [1;2;3;4;5] );
            delete( newFile );
            this.verifyEqual( channel.Values, [1;2;3;4;5] );
        end
        
    end
    
end