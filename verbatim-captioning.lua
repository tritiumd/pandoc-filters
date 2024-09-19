local pandoc=require('pandoc')
local fake = false -- if this is true the empty float env above and verbatim below
local function stringify(v)
    pstringify = (require 'pandoc.utils').stringify
    if (v ~= nil or v ~= '')
    then
        return pstringify(v)
    else
        return ''
    end
end
local function Meta(meta)
    if PANDOC_WRITER_OPTIONS.listings and not FORMAT:match 'latex' then return nil end
    if meta.verbatim_config and meta.verbatim_config.use_with_pandoc_crossref then
        fake = true
    else
        name = 'Verbatim'
        placement = 'H'
        listname='List of Verbatim'
        if meta.verbatim_config then
            if meta.verbatim_config.floatname then name = stringify(meta.verbatim_config.floatname) end
            if meta.verbatim_config.placement then placement = stringify(meta.verbatim_config.placement) end
            if meta.verbatim_config.listname then listname = stringify(meta.verbatim_config.listname) end
            if meta.verbatim_config.fake then
                fake = meta.verbatim_config.fake
                placement = "H"
            end
        end
        includes = [[
        \@ifpackageloaded{float}{}{\usepackage{float}}
        \floatstyle{ruled}
        \@ifundefined{c@chapter}{\newfloat{codelisting}{]]..placement..[[}{lop}}{\newfloat{codelisting}{]]..placement..[[}{lop}[chapter]}
        \floatname{codelisting}{]]..name..[[}
        \newcommand*\listoflistings{\listof{codelisting}{]]..listname..'}}'
        if meta['header-includes'] then
            table.insert(meta['header-includes'], pandoc.RawBlock('tex', includes))
        else
            meta['header-includes'] = pandoc.List:new{pandoc.RawBlock('tex', includes)}
        end
    end
    return meta
end


local function CodeBlock(elem)
    meta = meta_local
    if PANDOC_WRITER_OPTIONS.listings or not FORMAT:match 'latex' then return nil end
    if not elem.attributes['caption'] then return nil end
    caption = elem.attributes['caption']
    id = elem.identifier
    elem.attributes['caption'] = ''
    elem.identifier = ''
    data = ''
    if caption then data = data .. '\\caption{'.. caption ..'}' end
    if id then data = data .. '\\label{'.. id ..'}' end
    if fake then
        return {
            pandoc.RawBlock('tex','\\begin{codelisting}'.. data ..'\\end{codelisting}\\vspace*{-0.75cm}'),
            elem
        }
    else
         return {
             pandoc.RawBlock('tex','\\begin{codelisting}\n'),
             elem,
             pandoc.RawBlock('tex', '\n'.. data ..'\\end{codelisting}')
         }
    end
end

return {{Meta = Meta},{CodeBlock=CodeBlock}}