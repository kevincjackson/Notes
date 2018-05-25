# SMACSS Notes
*Scalable and Module Architecture for CSS* is an online guide by Jonathon Snook for writing CSS that works well on large websites .

## Base
Defaults and resets for all tag elements.
- If you found you've styled your base element, and you discover later you need another style for it, refactor out what is truly the base, and make modules for the variations (see below for module).
- Example) You thought you had a base table rule, but you might find out you actually need two modules such as `table-vertical`, and `table-horizontal`.

## Layout
Major divisions of the page.
- Use ID selectors because they are unique elements
- Typically there's only a handful like `#header`, `#footer`, and `#article`

## Modules
Reusuable elements. Think widgets.
- Prefix with name of module, like `pod`
- *Only* use classes!
- Do not use ID selectors or tags. They prevent reusability.
- If you have variations, add a subclass, like `pod-constrained`
- If you need to traverse, add classes to the subelements. This adds more markup, but is worth the cost for large websites.
```css
    .pod > .pod-featured
```
## State
States are overrides to styles which indicate *a Javascript dependency*.
- Examples: `is-hidden`, `is-collapsed`
- `!important` is allowed since it is an override
- May apply to base, layout, or modules. 
- A module would likely require an additional class such as `pod pod-is-disabled`

## Themes
Themes are overrides which change the look and feel of a site.
Themes could be implemented by loading a theme file last which simply redefines previous rules. 
- Ex)  Placing `body { background-color: black; }` in `nighttheme.css` which loads as the last file will override the previous `body` definition.
- Typography, for localization for example, can be overridden the same way.

## Depth (of Applicablity)
Prefer shallow selection rules.  Depth of 2 is better then depth of 6, and depth of 1 best of all.

Good
```css
    .pod > .pod-header
```
Bad 
```css
    body.article > #main > #content > #intro > p > b 
```
