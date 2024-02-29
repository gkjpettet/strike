# strike

Strike is a static site generator. Put simply, it takes a folder of Markdown files and a theme (a collection of HTML files) and uses those to create a completely self-contained website. Strike is the name of the engine (a Xojo module) and `strike` is the name of the command line tool.

I use Strike to build my [personal blog][blog] so it's production-ready.

The repository contains a Xojo Console application project that contains the Strike module.

- [Installation](#installation)
- [Quickstart](#quickstart)
- [Configuration](#config)
- [Content organisation](#content-organisation)
- [Frontmatter](#frontmatter)
- [Sections](#sections)
- [Slugs](#slugs)
- [Content example](#content-example)
- [Themes oveview](#themes-overview)
- [Using a theme](#using-a-theme)
- [Creating a theme](#creating-a-theme)
- [Disco](#disco)
- [The context](#the-context)
- [Variables](#variables)
- [Single templates](#single-templates)
- [List templates](#list-templates)
- [Homepage](#homepage)
- [Tags](#tags)
- [Archives](#archives)
- [Navigation](#navigation)
- [Pagination](#pagination)
- [RSS](#rss)

## <a id="installation">Installation</a>
Although Xojo is cross-platform, currently only macOS and Windows (64-bit) are supported. Although not tested, it should work just fine on Linux.

### macOS
On macOS, you can use the excellent [Homebrew][homebrew] package manager to quickly install the `strike` command line tool:

```no-highlight
brew tap gkjpettet/homebrew-strike
brew install strike
```

You can make sure that you've always got the latest version of Strike by running `brew update` in the Terminal. You'll know there's an update available if you see the following:

```no-highlight
==> Updated Formulae
gkjpettet/strike/strike ✔
```

To install it simply type `brew upgrade` in the Terminal. 

###   Windows
The easiest way to install the `strike` command line tool on Windows is with the [Scoop][scoop] package manager.

```no-highlight
scoop bucket add strike https://github.com/gkjpettet/scoop-strike
scoop install strike
```

## <a id="quickstart">Quickstart</a>
Let's get you up and started with a simple blog. The blog will list posts on the home page and contain just a single page. I'll assume you've already installed the `strike` command line tool as described above.

### Step 1: Create the basic site framework
Strike has a simple command for creating a new site that will create all the required files & folders for you to get working. Navigate the filesystem to where you want your site to be stored and execute the following command:

```no-highlight
$ strike create site my-blog
```

If everything is well, you should see something like the following:

```no-highlight
Success ✓
Your new site was created in /Users/garry/Desktop
A single post and a simple page have been created in /content. 
A simple default theme called 'primary' has been created for you in /themes.
Feel free to create your own with `strike3 create theme [name]`.
```

You can check out the contents of your new site with `ls`:

```no-highlight
config.toml   content   site.data   storage   themes
```

As you can see, a Strike site has a very simple basic structure: three folders, a configuration file and a SQLite database. Let’s look at them one-by-one:

#### config.toml
Every website must have a configuration file at its root in [TOML] format. The settings within `config.toml` apply to the whole site. Required and valid options are detailed in the [configuration](#config) section. Additionally, you can provide site-wide data that's accessible from themes in this file.

#### content/
As the name suggests, this is where you store the content of your website. Inside `content/` you create folders for different sections. Let’s suppose our blog has three types of content: posts, reviews and tutorials. You would then create three folders in `content/` titled `post/`, `review/` and `tutorial/` (note I’ve used the singular form of the word as it looks better in the resultant URLs). The name of the section is important as it affects not only the final URL but also the styling applied to the page by the theme (as themes can style sections differently from one another if you wish). A simple blog doesn’t require any sections, you can just place Markdown files in the root of the `content/` folder too if you wish.

#### site.data
This is a SQLite database which is used to cache your content for faster building. You shouldn't really ever need to edit this.

#### storage/
Any file or folder you place in here will be copied to `/public/storage` in the built site. This is a good location to put images, etc.

#### themes/
This is the folder to place themes that you have created or downloaded. They are then applied by specifying their name in `config.toml` (read more about themes [here](#themes-overview)).

### Step 2: Add content
Helpfully, when creating a new site, Strike also creates some dummy content for us. Strike3 creates a post called `Hello World.md` in `content/` and a simple about page in `/content/about/`. You can keep and edit these or delete them and add your own content. Just use your favourite editor (I use Panic's [Nova]).

If you open up the sample post created by Strike (`/content/Hello World.md`), you’ll see an example of (optional) _frontmatter_ which looks like this:

```toml
+++
title =  "Hello World!"
+++
```

Note the flanking three `+` characters in the [frontmatter](#frontmatter) which separate it from your post content.

### Step 3: Set the theme
Every site needs a theme and Strike supports a comprehensive theming system. You can either create your own or download one made by our community. Helpfully, Strike provides a very simple theme to get you started called `skeleton`. Strike sets this as your site’s theme when you create a new site. Using a different theme is easy - just copy the theme folder you want to use  to `themes/` in the site root and set the `theme` value in `config.toml` to the theme name. You can read more about this [here](#themes-overview).

### Step 4: Build the site
Building your site is quick and easy. Just navigate to the root of your site a Terminal and type: `strike build`:

```no-highlight
$ strike build
Success ✓
Site built in 80 ms
```

### Step 5: Upload your site
To publish your site just copy the entire contents of the `public/` folder created by the build command to the root of your web host.

## <a id="config">Configuration</a>
Strike requires the presence of a configuration file in the root of the site directory named `config.toml`. Not only does this contain a number of mandatory values needed by Strike to build your site but it can specify additional options and contain arbitrary data for your themes to use.

Below is the configuration file created by Strike when you run the `strike3 create site` command:

```toml
alphabeticalSections = []
archives = false
baseURL = "/"
buildDrafts = false
description = "My awesome site"
includeHomeLinkInNavigation = false
postsPerPage = 10
rss = false
rssExcludedSections = []
siteName = "My Site"
theme = "skeleton"
```

Omitting any of the values above will cause Strike to use its defaults. A list of all values controlling site creation recognised by Strike are listed below:

```toml
# By default on a listing page, posts are ordered by their publication date. This behaviour can be overridden on a per-section basis
# so posts are ordered alphabetically by their title. To do this, populate this array with the name of the section(s) desired.
alphabeticalSections = []

# Whether or not to build the archive listings (set to true if active theme demands it).
archives = true

# Hostname (and path) to the root, e.g. https://mysite.com
baseURL = "/"

# Whether posts with `isDraft = true` in their frontmatter should be rendered when building the site.
buildDrafts = false

# A description of the site. Used in some themes as a tagline.
description = "My awesome site"

# If `true` then a link to the home page is prepended to the site's top level navigation.
includeHomeLinkInNavigation = false

# The number of posts to show on listing pages. Set to `-1` to list all posts in that section..
postsPerPage = 10

# Whether or not to build an RSS feed at `/rss.xml`.
rss = false

# By default, all posts are included in the RSS feed. You can specify sections to exclude from the feed by adding them to this array.
rssExcludedSections = []

# The site's title.
siteName = "My Site"

# Theme name to use (this must be set to a valid theme in the `themes/` folder).
theme = "skeleton"
```

In addition to the values above, you are free to add any other valid TOML key/value and this will be accessible by all template files in the active theme. For instance, you may want to set details about the site author:

```toml
author = "Garry Pettet"
```

This would then be accessible from a theme template file with the tag `{{site.author}}`.

## <a id="content-organisation">Content organisation</a>
Content in a Strike site comprises Markdown text files with the extension `.md`. These files can have optional information at the very beginning called the [frontmatter](#frontmatter). Strike respects the hierarchical file/folder organisation you provide for your content to simplify things.

Strike expects your content to be arranged on disk in the same way that you want it to appear in the final rendered website. Without any additional configuration on your part, the following source organisation will just work and provide a functioning website:

```no-highlight
content
  - about
  --- index.md            // http://mysite.com/about
  - post
  --- First Post.md       // http://mysite.com/post/first-post.html
  --- Second Post.md      // http://mysite.com/post/second-post.html
  --- sub-section
  ------ Third Post.md    // http://mysite.com/post/sub-section/third-post.html
  - review
  --- Die Hard.md         // http://mysite.com/review/die-hard.html
```

You can nest content at any level but the top level folders within the `content/` folder are special and are either [sections](#sections) or **pages**.

### Structure
It makes sense that the way you store your files on disk is the way you want them displayed to the user in the final rendered website. As displayed above, the organisation of your source content will be mirrored in the URLs of your site. Notice that the top level `/about` page URL was created using a directory named `about/` with a single `index.md` file inside. This is the organisation format you should use to create a single page. Creating a top-level folder containing Markdown files without an `index.md` file creates a [section](#sections) rather than a page. The `index.html` for that section will be automatically created by Strike during the build process.

Sometimes, you need more granular control over your content. In these cases, you can use the [frontmatter](#frontmatter) at the beginning of each Markdown file to do just that.

## <a id="frontmatter">Frontmatter</a>
Frontmatter is great. It not only allows some flexibility to how posts appear and when they are published but it allows provides you with the ability to add custom data to a post that can then be used by themes.

Strike supports frontmatter in TOML format. Although optional, if you include frontmatter in your Markdown files, it must occur at the very top of the file. Frontmatter is identified by flanking it with `+++`. Example:

```toml
+++
title = "My first post",
date = "2024-02-28 09:10"
+++
```

### Frontmatter variables
Variables can be accessed from within a theme template file simply by enclosing the variable name in double curly braces, like so: `{{title}}`. There are a few predefined variables that Strike uses and will create for you if not specified in the frontmatter or if no frontmatter is defined:

#### date
The publication date for the content. Should be in SQL date format. Valid examples include: `2024-02-28 10:40`, `2024-02-28` and `2024-02-28 10:40:35`. If not specified then Strike will use the modification date of the file. If the publication date is in the future then the content will not be rendered.

#### draft
If `true` then this post will not be rendered _unless_ the `buildDrafts` value in the site’s `config.toml` file is set to `true`.

#### slug
A post’s slug is automatically created by Strike but can be overridden/customised with this variable if desired. 

#### title
The title for the content. If not specified in the frontmatter then Strike will slugify the file name.

## <a id="sections">Sections</a>
As discussed in the [content organisation](#content-organisation) section, how you organise your content in the file system is mirrored in the final built site. With this in mind, Strike uses the top level folders within the `content/` folder as the **section**.

The following example site has a static home page and two sections - `post` and `review`:

```no-highlight
content
  - index.md              // http://example.com/
  - post
  --- First Post.md       // http://example.com/post/first-post.html
  --- Second Post.md      // http://example.com/post/second-post.html
  - review
  --- Die Hard.md         // http://example.com/review/die-hard.html
  --- Star Trek.md        // http://example.com/review/star-trek.html
```

### Section lists
If a file titled `index.md` is located within a top-level (section) folder then Strike will render that at `/section-name/index.html`. If no `index.md` file is present then Strike will automatically generate an index page listing all content within that section. It will automatically paginate the index if there are more posts than specified in the `postsPerPage` variable in the site’s `config.json` file. For example if `postsPerPage = 10` and there are 18 posts in our review section, Strike will create a site structure as below:

```no-highlight
http://example.com/review         // listing of first 10 reviews
http://example.com/review/page/2  // listing of reviews 11-18
```

If `postsPerPage = -1` in `config.toml` then all posts in that section will be shown without pagination.

For more information on how to style these automatically generated lists from a theme, including how to access information on the individual posts in the list, see the [list templates](#list-templates) section.

## <a id="slugs">Slugs</a>
Just so we’re all clear, let’s look at an illustration of the terms used to describe both a content path (i.e. a file path within your `content/` folder) and a URL. The following file path:

```no-highlight
`content/review/Die Hard.md`
```

will generate this URL:

```no-highlight
`http://example.com/review/die-hard.html`
```

Where **example.com** is the `baseURL` value in `config.toml`, **review** is the [section](#sections) (a folder titled `review/` in the `content/` folder) and **die-hard** is the **slug**. 

The slug is created automatically by Strike from the file name by removing/substituting illegal URL characters. You can specify your own slug for a post by adding it to the post's [frontmatter](#frontmatter) as described above and as demonstrated below:

```toml
slug = "my-great-slug"
```

## <a id="content-example">Content example</a>
They say a picture is worth a thousand words. To that effect, below is a basic example of a content file written in Markdown. We’ll assume its file path is `my-site/content/review/Die Hard.md`. This will result in a final URL of `http://example.com/review/die-hard.html`. Kudos to [Empire][die hard review] for the text.

```markdown
+++
title = "Die Hard Review"
date = 2016-12-06 16:39"
+++

## Intro
New York cop _John McClane_ is visiting his estranged wife Holly in LA for
Christmas. Arriving in time for her Christmas party at the Nakatomi Plaza
skyscraper, he is unfortunately also just in time to see terrorists take
everyone there hostage. As the only cop inside the building, McClane does 
his best to sort the situation out.

## About
The smart-mouthed, high-rise thriller which launched [Bruce Willis][hero] as 
an action figure and accidentally rekindled Hollywoods enthusiasm for 
disaster movies (a worthy 80s cousin to The Towering Inferno). Die Hard has 
proved a reliable video fixture for the home and looks great on DVD; just 
dying to be racked alongside its two successors.

## Verdict
John McClane's smartmouthed New York cop was a career-defining turn, mixing 
banter, action heroics and a dirty white vest to stunning effect. Acting up 
to him every step of the way is [Alan Rickman][rickman], at his sneering 
best - but the script and cast are pretty much flawless. The very pinnacle 
of the '80s action movie, and if it's not the greatest action movie ever 
made, then it's damn close.

[hero]: https://en.wikipedia.org/wiki/Bruce_Willis
[rickman]: https://en.wikipedia.org/wiki/Alan_Rickman
```

This would be rendered as below:

```html
<h2>Intro</h2>
<p>New York cop <em>John McClane</em> is visiting his estranged wife Holly in LA for Christmas. 
Arriving in time for her Christmas party at the Nakatomi Plaza skyscraper, he is unfortunately 
also just in time to see terrorists take everyone there hostage. As the only cop inside the building, 
McClane does his best to sort the situation out.</p>

<h2>About</h2>
<p>The smart-mouthed, high-rise thriller which launched 
<a href="https://en.wikipedia.org/wiki/Bruce_Willis">Bruce Willis</a> as an action figure and 
accidentally rekindled Hollywoods enthusiasm for disaster movies (a worthy 80s cousin to 
The Towering Inferno). Die Hard has proved a reliable video fixture for the home and looks great 
on DVD; just dying to be racked alongside its two successors.</p>

<h2>Verdict</h2>
<p>John McClane’s smartmouthed New York cop was a career-defining turn, mixing banter, 
action heroics and a dirty white vest to stunning effect. Acting up to him every step of the way 
is <a href="https://en.wikipedia.org/wiki/Alan_Rickman">Alan Rickman</a>, at his sneering 
best - but the script and cast are pretty much flawless. The very pinnacle of the ‘80s action 
movie, and if it’s not the greatest action movie ever made, then it’s damn close.</p>
```

## <a id="themes-overview">Themes overview</a>
Strike has a powerful but simple theming system which is capable of styling both basic and complicated sites. As an example this very site is built with Strike using a theme I built in an afternoon (version {{strike.version}} to be precise).

Strike themes are powered by Strike's **Disco engine** and are therefore termed **Disco themes**. Disco themes are deliberately logic-less as their purpose is purely for the display of content. This means that anybody with a basic knowledge of HTML and CSS can create a beautiful theme. Disco themes are structured in a way to reduce code duplication and are ridiculously easy to install and modify.

Strike currently ships with a simple default theme called `skeleton` to get you started.

## <a id="using-a-theme">Using a theme</a>

### Installing a theme
To install a theme someone else has created, simply download the new theme's folder and place it in the `themes/` folder within the root of your site. To activate it, set the value of the `theme` variable in the site’s `config.toml` file to the name of the theme’s folder and rebuild the site.

### Creating your own theme
It is very much encouraged that you create your own theme. Not only will this give you full creative control over how your site looks but it’s really quite straightforwards and requires only a small amount of confidence with HTML and CSS.

## <a id="creating-a-theme">Creating a theme</a>
Strike can create a new theme for you in your `themes/` directory with the `create theme` command:

```no-highlight
$ strike create theme [theme-name]
```

This command will initialise all of the files and folders a basic theme requires. Strike themes are written in the [Disco templating language](#disco) which is essentially HTML with a few Strike specific tags to inject content-related stuff.

### Theme components
A theme comprises template files and static assets (such as CSS and javascript). Below are the files & folders required for a valid theme:

```no-highlight
assets/
layouts/
 - 404.html
 - archives.html
 - archives-home.html
 - home.html
 - list.html
 - page.html
 - post.html
 - tags.html
 -- partials/
theme.json
```
This structure is created with the `create theme` command.

#### theme.json
This is the theme’s configuration file in JSON format. There are currently three variables within:

- `name`: The name of the theme
- `description`: A brief description of the theme
- `minVersion`: The minimum version of Strike required to use the theme using the [semantic version] format.

#### assets/
This is where a theme should store all of its static assets - things like CSS, javascript and image files. After building, they will be copied to `public/assets/`. Files placed here are accessible from within a theme template file with the tag `{{assets}}`. For example, if your theme has a stylesheet called `styles.css`, you might want to organise it as follows:

```no-highlight
- assets/
-- css/
--- styles.css
```

`styles.css` would then be copied to `public/assets/css/styles.css`. You can access it from your theme template files with `{{assets}}/css/styles.css`.

#### layouts/
This is the meat of the theme. The `layouts/` folder contains the various template files which specify how certain pages are rendered. It contains a single folder, `partials/` which contains template files (partial views) that can be injected into other template files. `layouts/` also contains the seven template files listed below:

- `404.html`: Detail on how to render the 404 page.
- `archives.html`: Controls how listing pages for archive years, months and days are rendered.
- `archives-home.html`: Controls how the `/archive/index.html` page is rendered.
- `home.html`: If a static home page is required, this controls how it’s rendered.
- `list.html`: How to display the default list of content.
- `page.html`: Default rendering for a page.
- `post.html`: Default rendering for a single post.
- `tags.html`: How the page listing posts by tag is rendered.

Additionally, a theme can have folders within `layouts/` named the same as sections in the site which specifiy how content in those sections is rendered. For example, suppose my content is structured as follows:

```no-highlight
content
- index.md
- post/
-- first-post.md
- review/
-- Die Hard.md
- Another Post.md
```

I can easily style the appearance of a `post` and a `review` differently in a theme with the following structure

```no-highlight
- theme.json
- assets/
- layouts/
-- partials/
-- post
--- post.html     // will style http://example.com/post/first-post.html
--- list.html     // will style http://example.com/post/
-- review
--- post.html     // will style http://example.com/review/die-hard.html
--- list.html     // will style http://example.com/review/
-- 404.html
-- archive.html
-- archives.html
-- home.html      // will style http://example.com/index.html
-- list.html
-- post.html      // will style http://example.com/another-post.html
```

You don't have to specify both a `post.html` and a `list.html` file for each section as, if not present, the default `layouts/post.html` and `layouts/list.html` files will be used.

## <a id="disco">Disco</a>
Disco is Strike's templating language. In essence, it is normal HTML with an optional number of **tags** that will be transformed by Strike during rendering into the required value.

### Basic syntax
As mentioned above, Disco template files are normal HTML files with the `.html` file extension but with the addition of variables and functions known as **tags**. Tags are enclosed within double curly braces.

### Template variables
Each template file has a `context` object made available to it. Strike passes either a _post context_ or a _list context_ to a template file, depending on the type of content being rendered. More detail is available in the [variables](#variables) section.

A variable is accessed by referencing the variable’s name within a tag, e.g. the `title` variable:

```html
<title>{{title}}</title>
```

### Partials
To include the contents of another template file in a template file, we use the `{{partial template-name}}` tag where `template-name` is the name of a template file in the `partials/` folder (minus the `.html` extension).

For example, given a file called `header.html` in `partials/` like this:

```html
<!doctype html>

<html lang="en">
<head>
  <meta charset="utf-8">
  <link href="{{assets}}/css/bootstrap.min.css" rel="stylesheet">
</head>
```

We can include it in our `post.html` template file like this:

```html
{{partial header}}

<body>
  <p>Hello!</p>
</body>
```

### Iteration
Disco is deliberately logic-less. The only exception is the `{{foreach}}...{{endeach}}` block. Tags and HTML enclosed within this block are run for each post in the current `context`. For example, if we assume that the current context has three pages then the following code:

```html
{{foreach}}
  <h2>{{title}}</h2>
  <p>Posted at {{date.hour}}:{{date.minute}}</p>
  <hr />
{{endeach}}
```

Would output the following HTML:

```html
<h2>My first post<h2/>
<p>Posted at 13:15<p/>
<hr />
<h2>My second post<h2/>
<p>Posted at 08:05<p/>
<hr />
<h2>My third post<h2/>
<p>Posted at 20:45<p/>
<hr />
```

The `{{foreach}}...{{endeach}}` block only has meaning in list templates. By default, the posts are iterated over by publication date but this can be changed (on a per-section basis) to alphabetically by title by using the `alphabeticalSections` key in the `config.toml` file.

## <a id="the-context">The context</a>
Every template file is passed a `context`. There are two types of context that a template file may be passed: a _list context_ or a _post context_. Each type of context has its own unique variables assigned to it by Strike and there are a number of base variables common to both types of context.

Single posts and pages have just one context. However, the context within a list page changes when within an iteration of a `{{foreach}}...{{endeach}}` block. This is because a list page represents a collection of posts, each one having its own context.

For example, in a single post the tag `{{title}}` returns the title of the post. However in a list post, within a `{{foreach}}...{{endeach}}` block the `{{title}}` tag returns the title of the post in the current iteration. Consider the following three Markdown files:

#### File structure:
```no-highlight
content/review/Die Hard.md    // http://example.com/review/die-hard.html
content/review/Avatar.md      // http://example.com/review/avatar.html
content/review/Star Trek.md   // http://example.com/review/star-trek.html
```

#### Die Hard.md
```markdown
+++
title = "Die Hard (1988)"
+++

## Yippee ki-yay!
```

#### Avatar.md
```markdown
+++
title = "Avatar (2009)"
+++

## Open Pandora's box
```

#### Star Trek.md
```markdown
+++
title = "Star Trek (2009)"
+++

## To boldly go where no one has gone before
```

When Strike renders the page `http://example.com/review/avatar.html` it will call the `post.html` template file for the theme. Let’s say the contents of that file is:

```html
<h2>{{title}}</h2>
```

The output will be:

```html
<h2>Avatar (2009)</h2>
```

If, however, Strike is rendering a list of the all the reviews at `http://example.com/review/index.html` it will call the `list.html` template file. Let’s say the contents of that file is:

```html
{{foreach}}
  <h2>{{title}}</h2>
  <hr />
{{endeach}}
```

The output will be:

```html
<h2>Die Hard (1988)</h2>
<hr />
<h2>Avatar (2009)</h2>
<hr />
<h2>Star Trek (2009)</h2>
<hr />
```

## <a id="variables"></a>Variables
As mentioned in the [context section](#the-context), Strike makes available a number of variables to template files through their `context`. The following variables are available for use in template files within a theme.

### Site variables
The value of any variable in the site’s `config.toml` file can be retrieved from any template file with the tag `{{site.variable-name}}`, this includes user-defined variables. This is the preferred method to set global data values.

For example, to get the base URL of the entire site from within a template file, simply use the tag `{{site.baseURL}}`.

### All context variables
The following is a list of the variables available to both _post contexts_ and _list contexts_. In the case of **post** contexts, all may be overridden in the [frontmatter](#frontmatter). Remember, these are all accessed by enclosing in double curly braces, e.g: `{{variable name}}`.

- `{{assets}}`: The public URL to the current theme's `assets/` folder
- `{{content}}`: The rendered content of the context's file
- `{{date}}`: The date of the content in SQL format
- `{{date.second}}`: The second component of the content’s date (two digits)
- `{{date.minute}}`: The minute component of the content’s date (two digits)
- `{{date.hour}}`: The hour component of the content’s date (two digits)
- `{{date.day}}`: The day component of the content’s date (two digits)
- `{{date.month}}`: The month component of the content’s date (two digits)
- `{{date.longMonth}}`: The month component of the content’s date (e.g. January)
- `{{date.shortMonth}}`: The month component of the content’s date (e.g. Jan)
- `{{date.year}}`: The year component of the content’s date (four digits)
- `{{date.shortYear}}`: The year component of the content’s date (two digits)
- `{{feedURL}}`: The URL to the site's RSS feed (if enabled in the site's [configuration](#config))
- `{{firstParagraph}}`: The first paragraph of this post including HTML.
- `{{navigation}}`: Unordered HTML list of the site contents
- `{{nextPost}}`: The URL to the next post in this section
- `{{permalink}}`: The permalink URL to the content
- `{{previousPost}}`: The URL to the previous post in this section
- `{{readingTime}}`: Estimated reading time for the content (e.g. “3 min read”)
- `{{storage}}`: The public URL to the `storage/` folder
- `{{summary}}`: A summary of the content (first 55 words) with HTML stripped
- `{{tags}}`: Unordered HTML list of the content's tags
- `{{title}}`: The title of the content
- `{{wordCount}}`: The number of words in the content

### List context variables
List pages are automatically created by Strike at the root of the site as `http://example.com/index.html` (unless a static homepage is specified) and at the root of every section (e.g. `http://example.com/review/index.html`) and are rendered by `list.html` template files. The following is a list of variables accessible from `list.html` template files. Note the tags all start with `list.`.

- `{{list.archiveDateRange}}`: The archive date range that posts in this context are drawn from. E.g: "2023" or "February 23 2024".
- `{{list.archiveDay}}`: Only valid on archive list pages. This is the day (1-31) of the posts being listed otherwise it's `-1`
- `{{list.archiveMonth}}`: Only valid on archive list pages. This is the month (1-12) of the posts being listed otherwise it's `-1`
- `{{list.archiveYear}}`: Only valid on archive list pages. This is the year of the posts being listed otherwise it's `-1`
- `{{list.nextPage}}`: The URL to the next page in a paginated list of posts
- `{{list.prevPage}}`: The URL to the previous page in a paginated list of posts
- `{{list.tag}}`: If this is a tag listing page, this is the tag being listed

### Archive variables
- `{{archives.months}}`: HTML list of your site’s content by month (e.g. Jan)
- `{{archives.longMonths}}`: HTML list of your site’s content by month (e.g. January)
- `{{archives.url}}`: The URL to your site’s archive listing page (e.g. `http://example.com/archive/`)

### Helper variables
- `{{helper.day}}`: The day component of the current date (two digits)
- `{{helper.longMonth}}`: The month component of the current date (e.g. January)
- `{{helper.shortMonth}}`: The month component of the current date (e.g. Jan)
- `{{helper.month}}`: The month component of the current date (two digits)
- `{{helper.year}}`: The year component of the current date (four digits)

### Strike variables
- `{{strike.generator}}`: Meta tag for the version of Strike that built the site. I’d be very grateful if you would include it in all theme headers so I can track the usage and popularity of Strike as a tool. Example output: `<meta name="generator" content="Strike {{strike.version}}" />`
- `{{strike.version}}`: Strike's version number

## <a id="single-templates">Single templates</a>
Single content is the term for posts and pages. For every Markdown file in the `content/` folder (except the homepage), Strike will render it using either a `page.html` or `post.html` file from the currently active theme. Which template file is used is decided with this algorithm:

- Is the file `content/index.md`? If so then it’s a static homepage so render it with `layouts/home.html`
- Is the Markdown file in the root of `content/`? If yes then use `layouts/post.html`
- Is the Markdown file named `index.md` **and** the only file in a subfolder of `content/`?. If yes, it's a page so render with `layouts/page.html`
- Is the Markdown file in a section? If yes then use the `post.html` file for that section. For example, for the Markdown file `content/review/Die Hard.md` Strike will look first for `layouts/review/post.html` and use it. If that doesn’t exist then Strike will render the content with the default `layouts/post.html` file.

### Example post.html template file

```html
{{partial header}}

<div class="row">
  <div class="col-12">
	<article class="single">
	  <div class="post-meta">
		<h2 class="post-title">{{title}}</h2>
		<p class="post-date">{{date.longMonth}} {{date.day}}, {{date.year}}</p>
		{{tags}}
	  </div>
	  <div class="post-content">
		{{content}}
	  </div>
	</article>
  </div>
</div>
</main>
</div>
</div>

{{partial footer}}
```

## <a id="list-templates">List templates</a>
A list template is used to render multiple pieces of content in a single HTML file. Essentially, it's used to generate all `index.html` pages for the site (although optionally a different template can be used to render a static homepage).

For example, suppose I want a standard blog where the index page for the site (let’s say `https://example.com/`) lists all my blog posts in a paginated fashion. I also want a review section, separate from my blog that’ll store my movie reviews. I want that to have a listing too. I will structure my content as follows:

```no-highlight
content/
- Post 1.md
- Post 2.md
- Post 3.md
- Post 4.md
- review/
--- Review 1.md
--- Review 2.md
--- Review 3.md
```

This will lead to the site structure below:

```no-highlight
http://example.com/index.html             // auto-generated
http://example.com/post-1.html
http://example.com/post-2.html
http://example.com/post-3.html
http://example.com/post-4.html
http://example.com/review/index.html      // auto-generated
http://example.com/review/review-1.html
http://example.com/review/review-2.html
http://example.com/review/review-3.html
```

To render the main index page (`https://example.com/index.html`), Strike will use the default `layouts/list.html` template file. To render the listing for the reviews, Strike will first try to use `layouts/review/list.html`. If that file doesn’t exist then Strike will default to `layouts/list.html`. This allows themes to style the listing of sections differently.

### Example list.html template file
Observe the example `list.html` template file below:

```html
{{partial header}}

  <div class="row">
	<div class="col-12">
	  {{foreach}}
		<article class="list">
		  <h3 class="post-title">
			<a href="http://somesite.com">{{title}}</a>
			<span class="separator"> · </span>{{date.longMonth}} {{date.day}}, {{date.year}}
		  </h3>
		</article>
	  {{endeach}}
	</div><!--/.col-12-->
  </div><!--/.row-->
  <div class="row">
	<div class="col-12">
	  <div class="list-navigation">
		<a class="prev-page" href="{{previousPage}}">← Previous</a>
		<a class="next-page" href="{{nextPage}}">Next →</a>
	  </div><!--/.list-navigation-->
	</div><!--/.col-12-->
  </div><!--/.row-->
</main>
</div><!--/.container data-sticky-wrap-->

{{partial footer}}
```

## <a id="homepage">Homepage</a>
Believe it or not, the inability of a, shall remain nameless, dynamic website generator to create a static homepage was the “straw that broke the camel’s back” and drove me to write my own site generator in the first place.

A static homepage is the site’s landing page (i.e. the main `index.html` file) that is rendered differently from all the other site pages. Creating one is super easy with Strike. Put the content you want on your homepage in a Markdown file named `index.md` in the root of the site (i.e. `content/index.md`) and style it with the template file `layouts/home.html`. Job done.

## <a id="tags">Tags</a>
Strike supports the tagging of posts. A post can be assigned any number of tags (or none at all) within its [frontmatter](#frontmatter). To assign a tag or tags to a post simply add them in a TOML array called `tags` within the frontmatter:

```toml
+++
tags = ["review", "sci-fi"]
+++
```

### Getting a post's tags
Themes have easy access to a post's tags with the `{{tags}}` variable. Calling `{{tags}}` will output an unordered HTML list of the tags like so:

```html
<ul class="tags">
  <li><a href="/tag/review">review</a></li>
  <li><a href="/tag/sci-fi">sci-fi</a></li>
</ul>
```

### Listing content by tag
The posts tagged with a particular tag can be found at `public/tag/tag-name/index.html`. So in the above example we could view all posts tagged "sci-fi" by visiting `public/tag/sci-fi/index.html`.

## <a id="archives">Archives</a>
Strike will automatically add archives for your content. To disable this functionality just set the `archives` variable in `config.toml` to `false`.

When archives are enabled, Strike will create a top-level section in the built site at `/archive`. A page will be created at the root of this section (`archive/index.html`) for you to style how you wish with the `layouts/archives-home.html` template file.

Additionally, sub-folders will be created beneath `archive/` for each year and month that posts occur. For example, the following content:

```no-highlight
content
- Post 1.md     // publish date: Oct 1st 2016
- Post 2.md     // publish date: Sep 10th 2016
- Post 3.md     // publish date: Jan 22nd 2016
- Post 4.md     // publish date: Mar 4th 2015
- Post 5.md     // publish date: Feb 8th 2015
```

Would result in an archive as follows:

```no-highlight
http://example.com/archive/2016/index.html      // lists all 2016 posts
http://example.com/archive/2016/10/index.html   // lists October 2016 posts
http://example.com/archive/2016/9/index.html    // lists September 2016 posts
http://example.com/archive/2016/1/index.html    // lists January 2016 posts
http://example.com/archive/2015/index.html      // lists all 2015 posts
http://example.com/archive/2015/3/index.html    // lists March 2015 posts
http://example.com/archive/2015/2/index.html    // lists February 2015 posts
```

These listing pages are styled with the `layouts/archives.html` template file (note **archives** not **archives-home**).

See the [variables](#variables) section for more information on archive-specific template tags.

It’s worth noting that generating archives is computationally expensive. If you don’t need them then set the `archives` variable in `config.toml` file to `false`.

## <a id="navigation">Navigation</a>
Strike provides a simple way to include site navigation in your themes. Using the `{{navigation}}` tag within any template file will output an unordered
HTML list of all the sections and sub-sections of your site with permalinks to their roots. For example, given the following content:

```no-highlight
content/
- about/
- post/
- review/
```

The `{{navigation}}` tag would generate the following HTML:

```html
<ul class="site-nav">
  <li><a href="http://example.com/about">about</a></li>
  <li><a href="http://example.com/post">post</a></li>
  <li><a href="http://example.com/review">review</a></li>
</ul>
```

## <a id="pagination">Pagination</a>
Strike has full support for pagination. Whether or not pagination is required for a particular section depends on the `postsPerPage` variable in the site’s `config.toml` file. For instance, suppose we have a blog with the following structure:

```no-highlight
content
- Post 1.md
- Post 2.md
- Post 3.md
- Post 4.md
- Post 5.md
- Post 6.md
```

Strike will automatically create an index list page (because we have not specified a [static homepage](#homepage)) at `public/index.html` using the rendering information in the `list.html` template file of the current theme.

If we leave `postsPerPage` at the default value (`10`) then Strike will not need to paginate the index because we only have 6 posts. If however we change `postsPerPage` to 3 then Strike will not only create `public/index.html` (which will list the first three posts: `Post 1.md`, `Post 2.md` and `Post 3.md`) but it will also create a second page at `public/page/2/index.html` (which will list the last three posts: `Post 4.md`, `Post 5.md` and `Post 6.md`).

Of course if you wish you can set `postsPerPage` to `-1` and Strike won't paginate list pages.

Strike provides convenient tags to output the URLs of the previous and next pages. These tags are `{{list.nextPage}}` and `{{list.previousPage}}`. These tags are only valid in `list.html` and `archives.html` template files.

### Example usage
Here’s how I use these tags on this site, which is built with Strike:

```html
<div class="grid pagination">
	<div class="previous"><a class="previous" href="{{list.previousPage}}">Older Posts</a></div>
	<div class="next"><a class="next" href="{{list.nextPage}}">Newer Posts</a></div>
</div>
```

Which would render something like this (assuming we’re on page 2 of the list):

```html
<div class="grid pagination">
  <a class="previous" href="http://example.com/index.html">Previous</a>
  <a class="next" href="http://example.com/page/3/index.html">Next</a>
</div>
```

## <a id="rss">RSS</a>
Strike can optionally generate a RSS feed for your site if the `rss` variable is set to `true` within the site’s `config.toml` file. The feed adheres to the RSS 2.0 specification.

The feed will be saved to `public/rss.xml`. You can access the link to it from within a template file with the `{{feedURL}}` tag.

It’s worth noting that feed XML files can grow quite large. If you don’t want to provide a feed for your site then make sure you set the `rss` variable to `false` to reduce build times and reduce the size of the site to upload. It's `false` by default. You can limit the sections that are included in the feed using the `rssExcludedSections` array in the `config.toml` file.

[repo]: https://github.com/gkjpettet/strike
[toml]: https://toml.io/en/
[nova]: https://nova.app
[semantic version]: https://semver.org
[die hard review]: http://www.empireonline.com/movies/die-hard/review/
[blog]: https://garrypettet.com
 