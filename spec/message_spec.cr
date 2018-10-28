require "./spec_helper"

describe LSP::Message do
  describe ".from_json" do
    it "parses Cancel" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "method": "$/cancelRequest",
        "params": {
          "id": "example"
        }
      }
      EOF
      
      msg = msg.as LSP::Message::Cancel
      msg.params.id.should eq "example"
    end
    
    it "parses Initialize (minimal)" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "method": "initialize",
        "params": {
          "processId": 99,
          "rootUri": null,
          "capabilities": {}
        }
      }
      EOF
      
      msg = msg.as LSP::Message::Initialize
      msg.params.process_id.should eq 99
      msg.params._root_path.should eq nil
      msg.params.root_uri.should eq nil
      msg.params.options.should eq nil
      
      msg.params.capabilities.workspace.apply_edit.should eq false
      msg.params.capabilities.workspace.workspace_edit
        .document_changes.should eq false
      msg.params.capabilities.workspace.workspace_edit
        .resource_operations.should eq([] of String)
      msg.params.capabilities.workspace.workspace_edit
        .failure_handling.should eq "abort"
      msg.params.capabilities.workspace.did_change_configuration
        .dynamic_registration.should eq false
      msg.params.capabilities.workspace.did_change_watched_files
        .dynamic_registration.should eq false
      msg.params.capabilities.workspace.symbol
        .dynamic_registration.should eq false
      msg.params.capabilities.workspace.symbol.symbol_kind
        .value_set.should eq LSP::Data::SymbolKind.default
      msg.params.capabilities.workspace.execute_command
        .dynamic_registration.should eq false
      msg.params.capabilities.workspace.workspace_folders.should eq false
      msg.params.capabilities.workspace.configuration.should eq false
      
      msg.params.capabilities.text_document.synchronization
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.synchronization
        .will_save.should eq false
      msg.params.capabilities.text_document.synchronization
        .will_save_wait_until.should eq false
      msg.params.capabilities.text_document.synchronization
        .did_save.should eq false
      msg.params.capabilities.text_document.completion
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.completion.completion_item
        .snippet_support.should eq false
      msg.params.capabilities.text_document.completion.completion_item
        .commit_characters_support.should eq false
      msg.params.capabilities.text_document.completion.completion_item
        .documentation_format.should eq [] of String
      msg.params.capabilities.text_document.completion.completion_item
        .deprecated_support.should eq false
      msg.params.capabilities.text_document.completion.completion_item
        .preselect_support.should eq false
      msg.params.capabilities.text_document.completion.completion_item_kind
        .value_set.should eq LSP::Data::CompletionItemKind.default
      msg.params.capabilities.text_document.completion
        .context_support.should eq false
      msg.params.capabilities.text_document.hover
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.hover
        .content_format.should eq [] of String
      msg.params.capabilities.text_document.signature_help
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.signature_help.signature_information
        .documentation_format.should eq [] of String
      msg.params.capabilities.text_document.references
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.document_highlight
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.document_symbol
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.document_symbol.symbol_kind
        .value_set.should eq LSP::Data::SymbolKind.default
      msg.params.capabilities.text_document.document_symbol
        .hierarchical_document_symbol_support.should eq false
      msg.params.capabilities.text_document.formatting
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.range_formatting
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.on_type_formatting
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.definition
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.type_definition
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.implementation
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.code_action
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.code_action
        .code_action_literal_support.code_action_kind
        .value_set.should eq [] of String
      msg.params.capabilities.text_document.code_lens
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.document_link
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.color_provider
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.rename
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.rename
        .prepare_support.should eq false
      msg.params.capabilities.text_document.publish_diagnostics
        .related_information.should eq false
      msg.params.capabilities.text_document.folding_range
        .dynamic_registration.should eq false
      msg.params.capabilities.text_document.folding_range
        .range_limit.should eq 0
      msg.params.capabilities.text_document.folding_range
        .line_folding_only.should eq false
      
      msg.params.trace.should eq "off"
      
      msg.params.workspace_folders.should eq [] of LSP::Data::WorkspaceFolder
    end
    
    it "parses Initialize (maximal)" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "method": "initialize",
        "params": {
          "processId": 99,
          "rootPath": "/tmp/deprecated",
          "rootUri": "file:///tmp/example",
          "initializationOptions": {"foo": "bar"},
          "capabilities": {
            "workspace": {
              "applyEdit": true,
              "workspaceEdit": {
                "documentChanges": true,
                "resourceOperations": ["create", "delete", "rename"],
                "failureHandling": "transactional"
              },
              "didChangeConfiguration": { "dynamicRegistration": true },
              "didChangeWatchedFiles": { "dynamicRegistration": true },
              "symbol": {
                "dynamicRegistration": true,
                "symbolKind": {
                  "valueSet": ["Namespace"]
                }
              },
              "executeCommand": { "dynamicRegistration": true },
              "workspaceFolders": true,
              "configuration": true
            },
            "textDocument": {
              "synchronization": {
                "dynamicRegistration": true,
                "willSave": true,
                "willSaveWaitUntil": true,
                "didSave": true
              },
              "completion": {
                "dynamicRegistration": true,
                "completionItem": {
                  "snippetSupport": true,
                  "commitCharactersSupport": true,
                  "documentationFormat": ["markdown", "plaintext"],
                  "deprecatedSupport": true,
                  "preselectSupport": true
                },
                "completionItemKind": {
                  "valueSet": ["Folder"]
                },
                "contextSupport": true
              },
              "hover": {
                "dynamicRegistration": true,
                "contentFormat": ["markdown", "plaintext"]
              },
              "signatureHelp": {
                "dynamicRegistration": true,
                "signatureInformation": {
                  "documentationFormat": ["markdown", "plaintext"]
                }
              },
              "references": {
                "dynamicRegistration": true
              },
              "documentHighlight": {
                "dynamicRegistration": true
              },
              "documentSymbol": {
                "dynamicRegistration": true,
                "symbolKind": {
                  "valueSet": ["Namespace"]
                },
                "hierarchicalDocumentSymbolSupport": true
              },
              "formatting": {
                "dynamicRegistration": true
              },
              "rangeFormatting": {
                "dynamicRegistration": true
              },
              "onTypeFormatting": {
                "dynamicRegistration": true
              },
              "definition": {
                "dynamicRegistration": true
              },
              "typeDefinition": {
                "dynamicRegistration": true
              },
              "implementation": {
                "dynamicRegistration": true
              },
              "codeAction": {
                "dynamicRegistration": true,
                "codeActionLiteralSupport": {
                  "codeActionKind": {
                    "valueSet": ["exampleAction"]
                  }
                }
              },
              "codeLens": {
                "dynamicRegistration": true
              },
              "documentLink": {
                "dynamicRegistration": true
              },
              "colorProvider": {
                "dynamicRegistration": true
              },
              "rename": {
                "dynamicRegistration": true,
                "prepareSupport": true
              },
              "publishDiagnostics": {
                "relatedInformation": true
              },
              "foldingRange": {
                "dynamicRegistration": true,
                "rangeLimit": 500,
                "lineFoldingOnly": true
              }
            }
          },
          "trace": "verbose",
          "workspaceFolders": [
            {
              "uri": "file:///tmp/example/foo",
              "name": "foo"
            },
            {
              "uri": "file:///tmp/example/bar",
              "name": "bar"
            }
          ]
        }
      }
      EOF
      
      msg = msg.as LSP::Message::Initialize
      
      msg.params.process_id.should eq 99
      msg.params._root_path.should eq "/tmp/deprecated"
      msg.params.root_uri.as(URI).scheme.should eq "file"
      msg.params.root_uri.as(URI).path.should eq "/tmp/example"
      msg.params.options.should eq({"foo" => "bar"})
      
      msg.params.capabilities.workspace.apply_edit.should eq true
      msg.params.capabilities.workspace.workspace_edit
        .document_changes.should eq true
      msg.params.capabilities.workspace.workspace_edit
        .resource_operations.should eq(["create", "delete", "rename"])
      msg.params.capabilities.workspace.workspace_edit
        .failure_handling.should eq "transactional"
      msg.params.capabilities.workspace.did_change_configuration
        .dynamic_registration.should eq true
      msg.params.capabilities.workspace.did_change_watched_files
        .dynamic_registration.should eq true
      msg.params.capabilities.workspace.symbol
        .dynamic_registration.should eq true
      msg.params.capabilities.workspace.symbol.symbol_kind
        .value_set.should eq [LSP::Data::SymbolKind::Namespace]
      msg.params.capabilities.workspace.execute_command
        .dynamic_registration.should eq true
      msg.params.capabilities.workspace.workspace_folders.should eq true
      msg.params.capabilities.workspace.configuration.should eq true
      
      msg.params.capabilities.text_document.synchronization
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.synchronization
        .will_save.should eq true
      msg.params.capabilities.text_document.synchronization
        .will_save_wait_until.should eq true
      msg.params.capabilities.text_document.synchronization
        .did_save.should eq true
      msg.params.capabilities.text_document.completion
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.completion.completion_item
        .snippet_support.should eq true
      msg.params.capabilities.text_document.completion.completion_item
        .commit_characters_support.should eq true
      msg.params.capabilities.text_document.completion.completion_item
        .documentation_format.should eq ["markdown", "plaintext"]
      msg.params.capabilities.text_document.completion.completion_item
        .deprecated_support.should eq true
      msg.params.capabilities.text_document.completion.completion_item
        .preselect_support.should eq true
      msg.params.capabilities.text_document.completion.completion_item_kind
        .value_set.should eq [LSP::Data::CompletionItemKind::Folder]
      msg.params.capabilities.text_document.completion
        .context_support.should eq true
      msg.params.capabilities.text_document.hover
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.hover
        .content_format.should eq ["markdown", "plaintext"]
      msg.params.capabilities.text_document.signature_help
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.signature_help.signature_information
        .documentation_format.should eq ["markdown", "plaintext"]
      msg.params.capabilities.text_document.references
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.document_highlight
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.document_symbol
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.document_symbol.symbol_kind
        .value_set.should eq [LSP::Data::SymbolKind::Namespace]
      msg.params.capabilities.text_document.document_symbol
        .hierarchical_document_symbol_support.should eq true
      msg.params.capabilities.text_document.formatting
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.range_formatting
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.on_type_formatting
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.definition
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.type_definition
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.implementation
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.code_action
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.code_action
        .code_action_literal_support.code_action_kind
        .value_set.should eq ["exampleAction"]
      msg.params.capabilities.text_document.code_lens
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.document_link
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.color_provider
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.rename
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.rename
        .prepare_support.should eq true
      msg.params.capabilities.text_document.publish_diagnostics
        .related_information.should eq true
      msg.params.capabilities.text_document.folding_range
        .dynamic_registration.should eq true
      msg.params.capabilities.text_document.folding_range
        .range_limit.should eq 500
      msg.params.capabilities.text_document.folding_range
        .line_folding_only.should eq true
      
      msg.params.trace.should eq "verbose"
      
      msg.params.workspace_folders.size.should eq 2
      msg.params.workspace_folders[0].uri.scheme.should eq "file"
      msg.params.workspace_folders[0].uri.path.should eq "/tmp/example/foo"
      msg.params.workspace_folders[0].name.should eq "foo"
      msg.params.workspace_folders[1].uri.scheme.should eq "file"
      msg.params.workspace_folders[1].uri.path.should eq "/tmp/example/bar"
      msg.params.workspace_folders[1].name.should eq "bar"
    end
    
    it "parses Initialized" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "method": "initialized",
        "params": {}
      }
      EOF
      
      msg = msg.as LSP::Message::Initialized
    end
    
    it "parses Shutdown" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "method": "shutdown"
      }
      EOF
      
      msg = msg.as LSP::Message::Shutdown
    end
    
    it "parses Exit" do
      msg = LSP::Message.from_json <<-EOF
      {
        "jsonrpc": "2.0",
        "method": "exit"
      }
      EOF
      
      msg = msg.as LSP::Message::Exit
    end
    
    it "parses ShowMessageRequest::Response" do
      req = LSP::Message::ShowMessageRequest.new("example")
      reqs = {} of (String | Int64) => LSP::Message::AnyRequest
      reqs["example"] = req
      
      msg = LSP::Message.from_json <<-EOF, reqs
      {
        "jsonrpc": "2.0",
        "id": "example",
        "result": {
          "title": "Hello!"
        }
      }
      EOF
      
      msg = msg.as LSP::Message::ShowMessageRequest::Response
      msg.request.should eq req
      msg.result.as(LSP::Data::MessageActionItem).title.should eq "Hello!"
    end
  end
  
  describe "Any.to_json" do
    it "builds Cancel" do
      msg = LSP::Message::Cancel.new \
        LSP::Message::Cancel::Params.new("example")
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "method": "$/cancelRequest",
        "jsonrpc": "2.0",
        "params": {
          "id": "example"
        }
      }
      EOF
    end
    
    it "builds Initialize::Response (minimal)" do
      req = LSP::Message::Initialize.new "example"
      msg = req.new_response
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "result": {
          "capabilities": {
            "textDocumentSync": {
              "openClose": false,
              "change": 0,
              "willSave": false,
              "willSaveWaitUntil": false
            },
            "hoverProvider": false,
            "definitionProvider": false,
            "typeDefinitionProvider": false,
            "implementationProvider": false,
            "referencesProvider": false,
            "documentHighlightProvider": false,
            "documentSymbolProvider": false,
            "workspaceSymbolProvider": false,
            "codeActionProvider": false,
            "documentFormattingProvider": false,
            "documentRangeFormattingProvider": false,
            "renameProvider": false,
            "colorProvider": false,
            "foldingRangeProvider": false,
            "workspace": {
              "workspaceFolders": {
                "supported": false,
                "changeNotifications": false
              }
            },
            "experimental": {}
          }
        }
      }
      EOF
    end
    
    it "builds Initialize::Response (maximal)" do
      req = LSP::Message::Initialize.new "example"
      msg = req.new_response
      
      msg.result.capabilities.text_document_sync.open_close = true
      msg.result.capabilities.text_document_sync.change =
        LSP::Data::TextDocumentSyncKind::Incremental
      msg.result.capabilities.text_document_sync.will_save = true
      msg.result.capabilities.text_document_sync.will_save_wait_until = true
      msg.result.capabilities.text_document_sync.save =
        LSP::Data::ServerCapabilities::SaveOptions.new(true)
      
      msg.result.capabilities.hover_provider = true
      
      msg.result.capabilities.completion_provider =
        LSP::Data::ServerCapabilities::CompletionOptions.new(true, ["=", "."])
      
      msg.result.capabilities.signature_help_provider =
        LSP::Data::ServerCapabilities::SignatureHelpOptions.new(["("])
      
      msg.result.capabilities.definition_provider = true
      
      msg.result.capabilities.type_definition_provider =
        LSP::Data::ServerCapabilities::StaticRegistrationOptions.new([
          LSP::Data::DocumentFilter.new("crystal", "file", "*.cr")
        ], "reg")
      
      msg.result.capabilities.implementation_provider =
        LSP::Data::ServerCapabilities::StaticRegistrationOptions.new([
          LSP::Data::DocumentFilter.new("crystal", "file", "*.cr")
        ], "reg")
      
      msg.result.capabilities.references_provider = true
      
      msg.result.capabilities.document_highlight_provider = true
      
      msg.result.capabilities.document_symbol_provider = true
      
      msg.result.capabilities.workspace_symbol_provider = true
      
      msg.result.capabilities.code_action_provider =
        LSP::Data::ServerCapabilities::CodeActionOptions.new([
          "quickfix",
          "refactor",
          "source",
        ])
      
      msg.result.capabilities.code_lens_provider =
        LSP::Data::ServerCapabilities::CodeLensOptions.new(true)
      
      msg.result.capabilities.document_formatting_provider = true
      
      msg.result.capabilities.document_range_formatting_provider = true
      
      msg.result.capabilities.document_on_type_formatting_provider =
        LSP::Data::ServerCapabilities::DocumentOnTypeFormattingOptions.new(
          "}",
          ")",
          ":",
        )
      
      msg.result.capabilities.rename_provider =
        LSP::Data::ServerCapabilities::RenameOptions.new(true)
      
      msg.result.capabilities.document_link_provider =
        LSP::Data::ServerCapabilities::DocumentLinkOptions.new(true)
      
      msg.result.capabilities.color_provider =
        LSP::Data::ServerCapabilities::StaticRegistrationOptions.new([
          LSP::Data::DocumentFilter.new("crystal", "file", "*.cr")
        ], "reg")
      
      msg.result.capabilities.folding_range_provider =
        LSP::Data::ServerCapabilities::StaticRegistrationOptions.new([
          LSP::Data::DocumentFilter.new("crystal", "file", "*.cr")
        ], "reg")
      
      msg.result.capabilities.execute_command_provider =
        LSP::Data::ServerCapabilities::ExecuteCommandOptions.new(["x", "y"])
      
      msg.result.capabilities.workspace.workspace_folders.supported = true
      msg.result.capabilities.workspace.workspace_folders.change_notifications = "reg"
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "result": {
          "capabilities": {
            "textDocumentSync": {
              "openClose": true,
              "change": 2,
              "willSave": true,
              "willSaveWaitUntil": true,
              "save": {
                "includeText": true
              }
            },
            "hoverProvider": true,
            "completionProvider": {
              "resolveProvider": true,
              "triggerCharacters": [
                "=",
                "."
              ]
            },
            "signatureHelpProvider": {
              "triggerCharacters": [
                "("
              ]
            },
            "definitionProvider": true,
            "typeDefinitionProvider": {
              "documentSelector": [
                {
                  "language": "crystal",
                  "scheme": "file",
                  "pattern": "*.cr"
                }
              ],
              "id": "reg"
            },
            "implementationProvider": {
              "documentSelector": [
                {
                  "language": "crystal",
                  "scheme": "file",
                  "pattern": "*.cr"
                }
              ],
              "id": "reg"
            },
            "referencesProvider": true,
            "documentHighlightProvider": true,
            "documentSymbolProvider": true,
            "workspaceSymbolProvider": true,
            "codeActionProvider": {
              "codeActionKinds": [
                "quickfix",
                "refactor",
                "source"
              ]
            },
            "codeLensProvider": {
              "resolveProvider": true
            },
            "documentFormattingProvider": true,
            "documentRangeFormattingProvider": true,
            "documentOnTypeFormattingProvider": {
              "firstTriggerCharacter": "}",
              "moreTriggerCharacter": [
                ")",
                ":"
              ]
            },
            "renameProvider": {
              "prepareProvider": true
            },
            "documentLinkProvider": {
              "resolveProvider": true
            },
            "colorProvider": {
              "documentSelector": [
                {
                  "language": "crystal",
                  "scheme": "file",
                  "pattern": "*.cr"
                }
              ],
              "id": "reg"
            },
            "foldingRangeProvider": {
              "documentSelector": [
                {
                  "language": "crystal",
                  "scheme": "file",
                  "pattern": "*.cr"
                }
              ],
              "id": "reg"
            },
            "executeCommandProvider": {
              "commands": [
                "x",
                "y"
              ]
            },
            "workspace": {
              "workspaceFolders": {
                "supported": true,
                "changeNotifications": "reg"
              }
            },
            "experimental": {}
          }
        }
      }
      EOF
    end
    
    it "builds Shutdown::Response" do
      req = LSP::Message::Shutdown.new "example"
      msg = req.new_response
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "jsonrpc": "2.0",
        "id": "example",
        "result": null
      }
      EOF
    end
    
    it "builds ShowMessage" do
      msg = LSP::Message::ShowMessage.new \
        LSP::Message::ShowMessage::Params.new(
          LSP::Data::MessageType::Info,
          "Hello, World!"
        )
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "method": "window/showMessage",
        "jsonrpc": "2.0",
        "params": {
          "type": 3,
          "message": "Hello, World!"
        }
      }
      EOF
    end
    
    it "builds ShowMessageRequest" do
      msg = LSP::Message::ShowMessageRequest.new "example",
        LSP::Message::ShowMessageRequest::Params.new(
          LSP::Data::MessageType::Info,
          "Hello, World!",
          ["Hello!", "Goodbye!"]
        )
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "method": "window/showMessageRequest",
        "jsonrpc": "2.0",
        "id": "example",
        "params": {
          "type": 3,
          "message": "Hello, World!",
          "actions": [
            {
              "title": "Hello!"
            },
            {
              "title": "Goodbye!"
            }
          ]
        }
      }
      EOF
    end
    
    it "builds LogMessage" do
      msg = LSP::Message::LogMessage.new \
        LSP::Message::LogMessage::Params.new(
          LSP::Data::MessageType::Info,
          "Hello, World!"
        )
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "method": "window/logMessage",
        "jsonrpc": "2.0",
        "params": {
          "type": 3,
          "message": "Hello, World!"
        }
      }
      EOF
    end
    
    it "builds Telemetry" do
      msg = LSP::Message::Telemetry.new \
        JSON::Any.new({"foo" => JSON::Any.new("bar")})
      
      msg.to_pretty_json.should eq <<-EOF
      {
        "method": "telemetry/event",
        "jsonrpc": "2.0",
        "params": {
          "foo": "bar"
        }
      }
      EOF
    end
  end
end
