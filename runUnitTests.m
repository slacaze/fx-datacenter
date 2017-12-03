function runUnitTests( mode )
    if nargin < 1
        mode = 'fast';
    end
    switch mode
        case 'fast'
            testResults = runtests( 'fx.datacenter.test.unittest',...
                'IncludeSubpackages', true );
            disp( testResults );
        case 'codeCoverage'
            suite = matlab.unittest.TestSuite.fromPackage(...
                'fx.datacenter.test.unittest',...
                'IncludingSubpackages', true );
            runner = matlab.unittest.TestRunner.withTextOutput();
            jUnitPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(...
                fullfile( datacentertestroot, 'junitResults.xml' ) );
            coberturaReport = matlab.unittest.plugins.codecoverage.CoberturaFormat(...
                fullfile( datacentertestroot, 'codeCoverage.xml' ) );
            codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(...
                datacenterroot,...
                'IncludingSubfolders', true,...
                'Producing', coberturaReport );
            runner.addPlugin( jUnitPlugin );
            runner.addPlugin( codeCoveragePlugin );
            testResults = runner.run( suite );
            disp( testResults );
    end
end