// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Live Cells',
  tagline: 'A simple yet powerful reactive programming library',
  // favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://alex-gutev.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/live_cells/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'alex-gutev', // Usually your GitHub org/user name.
  projectName: 'live_cells', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
        },
        blog: {
          showReadingTime: true,
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      // image: 'img/docusaurus-social-card.jpg',
      navbar: {
        title: 'Live Cells',
        // logo: {
        //   alt: 'My Site Logo',
        //   src: 'img/logo.svg',
        // },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'tutorialSidebar',
            position: 'left',
            label: 'Basics',
          },
          {
              to: '/docs/category/advanced',
              label: 'Advanced',
              position: 'left'
          },
          // {to: '/blog', label: 'Blog', position: 'left'},
          // {
          //   href: 'https://github.com/facebook/docusaurus',
          //   label: 'GitHub',
          //   position: 'right',
          // },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Basics',
                to: '/docs/intro',
              },
            ],
          },
          {
            title: 'Pub.dev Packages',
            items: [
              {
                label: 'live_cells',
                href: 'https://pub.dev/packages/live_cells',
              },
              {
                label: 'live_cells_core',
                href: 'https://pub.dev/packages/live_cells_core',
              },
              {
                label: 'live_cell_extension',
                href: 'https://pub.dev/packages/live_cell_extension',
              },
            ],
          },
          {
            title: 'Source Code',
            items: [
              {
                label: 'GitHub',
                href: 'https://github.com/alex-gutev/live_cells',
              },
              {
                label: 'GitHub (Live Cell Extension)',
                href: 'https://github.com/alex-gutev/live_cell_extension',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Alexander Gutev.<br/>Built with Docusaurus.`,
      },
      prism: {
          theme: prismThemes.github,
          darkTheme: prismThemes.dracula,
          additionalLanguages: ['dart']
      },
    }),
};

export default config;
