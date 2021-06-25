require "json"

module LSP::Data
  # A document filter denotes a document through properties like language,
  # scheme or pattern.
  #
  # An example is a filter that applies to TypeScript files on disk. Another
  # example is a filter the applies to JSON files with name package.json:
  #     { language: 'typescript', scheme: 'file' }
  #     { language: 'json', pattern: '**/package.json' }
  struct DocumentFilter
    include JSON::Serializable

    # A language id, like `typescript`.
    property language : String?

    # A Uri [scheme](#Uri.scheme), like `file` or `untitled`.
    property scheme : String?

    # A glob pattern, like `*.{ts,js}`.
    property pattern : String?

    def initialize(@language = nil, @scheme = nil, @pattern = nil)
    end
  end
end
