local pandoc=require('pandoc')
local function Meta(meta)
    if PANDOC_WRITER_OPTIONS.listings and not FORMAT:match 'latex' then return nil end
    name = 'Verbatim'
    placement = 'H'
    if meta.verbatim_config then
        if meta.verbatim_config.floatname then name = meta.verbatim_config.floatname end
        if meta.verbatim_config.placement then placement = meta.verbatim_config.placement end
    end
    includes = [[
\usepackage{newfloat}
\usepackage{float}
\DeclareFloatingEnvironment[
fileext=los,
]]..
            'name='..name..',\n'..
            'placement='..placement..',\n'.. [[
]{coding}
]]

    if meta['header-includes'] then
        table.insert(meta['header-includes'], pandoc.RawBlock('tex', includes))
    else
        meta['header-includes'] = pandoc.List:new{pandoc.RawBlock('tex', includes)}
    end
    return meta
end

local function CodeBlock(elem)
    if PANDOC_WRITER_OPTIONS.listings and not FORMAT:match 'latex' then return nil end
    if not elem.attributes['caption'] then return nil end
    new = pandoc.RawBlock('tex','\\begin{coding}\n'
            .. pandoc.write ( pandoc.Pandoc({elem}),'latex' )
            .. '\\caption{'.. elem.attributes['caption'] ..'}\n'
            .. '\\end{coding}')
    elem.text=""
    reduce_spacing = pandoc.RawBlock('tex','\\vspace*{-2\\baselineskip}')
    return {new,elem,reduce_spacing}
end

return {{Meta = Meta},{CodeBlock=CodeBlock}}