require_relative "integration_helpers"

require "test_helper"

class KitchenSinkTest < ActionDispatch::IntegrationTest
  include IntegrationHelpers

  test "kitchen sink" do
    WebMock.stub_request(:get, /https:\/\/www.googleapis.com\/books\/v1\/volumes\?.+/)
      .to_return(
        status: 200,
        body: "{\n  \"kind\": \"books#volumes\",\n  \"totalItems\": 1,\n  \"items\": [\n    {\n      \"kind\": \"books#volume\",\n      \"id\": \"ySOBzgEACAAJ\",\n      \"etag\": \"GsDGfpufYH8\",\n      \"selfLink\": \"https://www.googleapis.com/books/v1/volumes/ySOBzgEACAAJ\",\n      \"volumeInfo\": {\n        \"title\": \"Crafting Interpreters\",\n        \"authors\": [\n          \"Robert Nystrom\"\n        ],\n        \"publishedDate\": \"2021-07-27\",\n        \"description\": \"Software engineers use programming languages every day, but few of us understand how those languages are designed and implemented. Crafting Interpreters gives you that insight by implementing two complete interpreters from scratch. In the process, you'll learn parsing, compilation, garbage collection, and other fundamental computer science concepts. But don't be intimidated! Crafting Interpreters walks you though all of this one step at a time with an emphasis on having fun and getting your hands dirty.\",\n        \"industryIdentifiers\": [\n          {\n            \"type\": \"ISBN_10\",\n            \"identifier\": \"0990582930\"\n          },\n          {\n            \"type\": \"ISBN_13\",\n            \"identifier\": \"9780990582939\"\n          }\n        ],\n        \"readingModes\": {\n          \"text\": false,\n          \"image\": false\n        },\n        \"pageCount\": 640,\n        \"printType\": \"BOOK\",\n        \"maturityRating\": \"NOT_MATURE\",\n        \"allowAnonLogging\": false,\n        \"contentVersion\": \"preview-1.0.0\",\n        \"panelizationSummary\": {\n          \"containsEpubBubbles\": false,\n          \"containsImageBubbles\": false\n        },\n        \"imageLinks\": {\n          \"smallThumbnail\": \"http://books.google.com/books/content?id=ySOBzgEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api\",\n          \"thumbnail\": \"http://books.google.com/books/content?id=ySOBzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api\"\n        },\n        \"language\": \"en\",\n        \"previewLink\": \"http://books.google.com/books?id=ySOBzgEACAAJ&dq=isbn:9780990582939&hl=&cd=1&source=gbs_api\",\n        \"infoLink\": \"http://books.google.com/books?id=ySOBzgEACAAJ&dq=isbn:9780990582939&hl=&source=gbs_api\",\n        \"canonicalVolumeLink\": \"https://books.google.com/books/about/Crafting_Interpreters.html?hl=&id=ySOBzgEACAAJ\"\n      },\n      \"saleInfo\": {\n        \"country\": \"US\",\n        \"saleability\": \"NOT_FOR_SALE\",\n        \"isEbook\": false\n      },\n      \"accessInfo\": {\n        \"country\": \"US\",\n        \"viewability\": \"NO_PAGES\",\n        \"embeddable\": false,\n        \"publicDomain\": false,\n        \"textToSpeechPermission\": \"ALLOWED\",\n        \"epub\": {\n          \"isAvailable\": false\n        },\n        \"pdf\": {\n          \"isAvailable\": false\n        },\n        \"webReaderLink\": \"http://play.google.com/books/reader?id=ySOBzgEACAAJ&hl=&printsec=frontcover&source=gbs_api\",\n        \"accessViewStatus\": \"NONE\",\n        \"quoteSharingAllowed\": false\n      },\n      \"searchInfo\": {\n        \"textSnippet\": \"&quot;A handbook for making programming languages&quot;--Back cover.\"\n      }\n    }\n  ]\n}\n"
      )
    WebMock.stub_request(:get, /https:\/\/www.googleapis.com\/books\/v1\/volumes\/.+/)
      .to_return(
        status: 200,
        body: "{\n  \"kind\": \"books#volume\",\n  \"id\": \"ySOBzgEACAAJ\",\n  \"etag\": \"yt/YRjuVcXk\",\n  \"selfLink\": \"https://www.googleapis.com/books/v1/volumes/ySOBzgEACAAJ\",\n  \"volumeInfo\": {\n    \"title\": \"Crafting Interpreters\",\n    \"authors\": [\n      \"Robert Nystrom\"\n    ],\n    \"publisher\": \"Genever Benning\",\n    \"publishedDate\": \"2021-07\",\n    \"description\": \"\\u003cp\\u003eDespite using them every day, most software engineers know little about how programming languages are designed and implemented. For many, their only experience with that corner of computer science was a terrifying \\\"compilers\\\"class that they suffered through in undergrad and tried to blot from their memory as soon as they had scribbled their last NFA to DFA conversion on the final exam.\\u003c/p\\u003e\\u003cp\\u003e\\u003cbr\\u003e\\u003c/p\\u003e\\u003cp\\u003eThat fearsome reputation belies a field that is rich with useful techniques and not so difficult as some of its practitioners might have you believe. A better understanding of how programming languages are built will make you a stronger software engineer and teach you concepts and data structures you'll use the rest of your coding days. You might even have fun.\\u003c/p\\u003e\\u003cp\\u003e\\u003cbr\\u003e\\u003c/p\\u003e\\u003cp\\u003eThis book teaches you everything you need to know to implement a full-featured, efficient scripting language. You'll learn both high-level concepts around parsing and semantics and gritty details like bytecode representation and garbage collection. Your brain will light up with new ideas, and your hands will get dirty and calloused.\\u003c/p\\u003e\\u003cp\\u003e\\u003cbr\\u003e\\u003c/p\\u003e\\u003cp\\u003eStarting from main(), you will build a language that features rich syntax, dynamic typing, garbage collection, lexical scope, first-class functions, closures, classes, and inheritance. All packed into a few thousand lines of clean, fast code that you thoroughly understand because you wrote each one yourself.\\u003c/p\\u003e\",\n    \"industryIdentifiers\": [\n      {\n        \"type\": \"ISBN_10\",\n        \"identifier\": \"0990582930\"\n      },\n      {\n        \"type\": \"ISBN_13\",\n        \"identifier\": \"9780990582939\"\n      }\n    ],\n    \"readingModes\": {\n      \"text\": false,\n      \"image\": false\n    },\n    \"pageCount\": 640,\n    \"printedPageCount\": 640,\n    \"dimensions\": {\n      \"height\": \"25.40 cm\",\n      \"width\": \"20.30 cm\",\n      \"thickness\": \"3.30 cm\"\n    },\n    \"printType\": \"BOOK\",\n    \"maturityRating\": \"NOT_MATURE\",\n    \"allowAnonLogging\": false,\n    \"contentVersion\": \"preview-1.0.0\",\n    \"panelizationSummary\": {\n      \"containsEpubBubbles\": false,\n      \"containsImageBubbles\": false\n    },\n    \"imageLinks\": {\n      \"smallThumbnail\": \"http://books.google.com/books/content?id=ySOBzgEACAAJ&printsec=frontcover&img=1&zoom=5&imgtk=AFLRE71nyjhPwjiMIOpjFKzLKvNZyY3ctxMku0xxyfmSIAngra4MdBXRp_MwxlV5JLQ0Dx60-GdtSw1UqzIi9uKKpLUsCw3wuEhG1tA3vf1WcwVxUyL1byxu6VZWpQnQYcIsJi1N1EXA&source=gbs_api\",\n      \"thumbnail\": \"http://books.google.com/books/content?id=ySOBzgEACAAJ&printsec=frontcover&img=1&zoom=1&imgtk=AFLRE70BVgcNQlenw1QrYBFCtMKorvg7wPdG78Dpl2oz83IN-MKpF4a4Gv3ydQ4Nqx-pI0mdewupEuCB9FTt-3F2HxUTR55WsYLiZo_y7cH3MeGMp3LOIA3F-InjxO02XfTujz7U54sF&source=gbs_api\"\n    },\n    \"language\": \"en\",\n    \"previewLink\": \"http://books.google.com/books?id=ySOBzgEACAAJ&hl=&source=gbs_api\",\n    \"infoLink\": \"https://play.google.com/store/books/details?id=ySOBzgEACAAJ&source=gbs_api\",\n    \"canonicalVolumeLink\": \"https://play.google.com/store/books/details?id=ySOBzgEACAAJ\"\n  },\n  \"saleInfo\": {\n    \"country\": \"US\",\n    \"saleability\": \"NOT_FOR_SALE\",\n    \"isEbook\": false\n  },\n  \"accessInfo\": {\n    \"country\": \"US\",\n    \"viewability\": \"NO_PAGES\",\n    \"embeddable\": false,\n    \"publicDomain\": false,\n    \"textToSpeechPermission\": \"ALLOWED\",\n    \"epub\": {\n      \"isAvailable\": false\n    },\n    \"pdf\": {\n      \"isAvailable\": false\n    },\n    \"webReaderLink\": \"http://play.google.com/books/reader?id=ySOBzgEACAAJ&hl=&printsec=frontcover&source=gbs_api\",\n    \"accessViewStatus\": \"NONE\",\n    \"quoteSharingAllowed\": false\n  }\n}\n"
      )

    authenticate

    grid_1_id = successful_authenticated_post("/grids/create", params: { name: "testGrid1" })["id"]
    grid_2_id = successful_authenticated_post("/grids/create", params: { name: "testGrid2"})["id"]

    cell_1_1_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 1, grid_id: grid_1_id })["id"]
    cell_2_1_id = successful_authenticated_post("/cells/create", params: { x: 2, y: 1, grid_id: grid_1_id })["id"]
    cell_1_2_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 2, grid_id: grid_1_id })["id"]
    cell_2_2_id = successful_authenticated_post("/cells/create", params: { x: 2, y: 2, grid_id: grid_1_id })["id"]

    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, grid_id: grid_2_id })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, x: 10, grid_id: grid_1_id })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, x: 2, y: 10 })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, y: 2 })

    successful_authenticated_post("/cells/read", params: { id: cell_2_2_id })

    cell_1_1_alt_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 1, grid_id: grid_2_id })["id"]

    book_id = successful_authenticated_post("/books/create", params: { isbn: "testISBN" })["id"]

    successful_authenticated_post("/books/update", params: { id: book_id, isbn: "newTestISBN" })

    successful_authenticated_post("/books/shelf", params: { id: book_id, cell_id: cell_1_1_id, index: 0 })

    failed_authenticated_post("/books/shelf", params: { id: book_id, cell_id: cell_1_1_id, index: 1 })

    successful_authenticated_post("/books/move", params: { id: book_id, cell_id: cell_1_1_id, index: 1 })
    successful_authenticated_post("/books/move", params: { id: book_id, cell_id: cell_1_1_id, index: 0 })
    
    tmp_book_id = successful_authenticated_post("/books/create_and_shelf", params: { isbn: "testISBN", cell_id: cell_1_1_id, index: 1 })["id"]

    failed_authenticated_post("/books/create_and_shelf", params: { isbn: "testISBN", cell_id: cell_1_1_id, index: 1 })

    successful_authenticated_post("/books/unshelf", params: { id: tmp_book_id })

    successful_authenticated_post("/books/destroy", params: { id: tmp_book_id })

    assert_not_nil(successful_authenticated_post("/books/read", params: { id: book_id })["location"])

    assert_equal(
      Set[cell_1_1_id, cell_1_2_id, cell_2_1_id, cell_2_2_id, cell_1_1_alt_id],
      successful_authenticated_post("/cells/list").map{ |cell| cell["id"] }.to_set
    )

    assert_equal(
      Set[cell_1_1_id, cell_1_2_id, cell_2_1_id, cell_2_2_id],
      successful_authenticated_post("/cells/list", params: { grid_id: grid_1_id }).map{ |cell| cell["id"] }.to_set
    )

    assert_equal(Set[book_id], successful_authenticated_post("/books/list").map{ |book| book["id"] }.to_set)
    
    assert_equal(
      Set[cell_1_1_alt_id],
      successful_authenticated_post("/cells/list", params: { grid_id: grid_2_id }).map{ |cell| cell["id"] }.to_set
    )

    assert_equal(
      Set[grid_1_id, grid_2_id],
      successful_authenticated_post("/grids/list").map{ |grid| grid["id"] }.to_set
    )

    successful_authenticated_post("/grids/update", params: { id: grid_1_id, name: "renamedTestGrid1" })

    assert_equal("renamedTestGrid1", successful_authenticated_post("/grids/read", params: { id: grid_1_id })["name"])

    failed_authenticated_post("/cells/destroy", params: { id: cell_1_1_id })

    successful_authenticated_post("/books/destroy", params: { id: book_id })

    successful_authenticated_post("/cells/destroy", params: { id: cell_1_1_id })

    assert_equal(
      Set[cell_1_2_id, cell_2_1_id, cell_2_2_id, cell_1_1_alt_id],
      successful_authenticated_post("/cells/list").map{ |cell| cell["id"] }.to_set
    )

    failed_authenticated_post("/grids/destroy", params: { id: grid_2_id })

    successful_authenticated_post("/cells/destroy", params: { id: cell_1_1_alt_id })

    successful_authenticated_post("/grids/destroy", params: { id: grid_2_id })
  end
end
