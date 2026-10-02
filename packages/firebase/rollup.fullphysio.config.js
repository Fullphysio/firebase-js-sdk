import rollupTypescriptPlugin from 'rollup-plugin-typescript2';
import typescript from 'typescript';
import builds from './rollup.config.js';

const bundles = ['firebase-remote-config.js', 'firebase-messaging.js'];

const typescriptPluginCDN = rollupTypescriptPlugin({
  typescript,
  check: false,
  include: ['*.ts', '**/*.ts', '*.js', '**/*.js'],
  tsconfigOverride: {
    compilerOptions: {
      declaration: false
    }
  }
});

export default builds
  .filter(build => bundles.includes(build.output.file))
  .map(build => ({
    ...build,
    plugins: build.plugins.map(plugin =>
      plugin.name === 'rpt2' ? typescriptPluginCDN : plugin
    )
  }));
