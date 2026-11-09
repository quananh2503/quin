package onenote

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNormalizeOneNoteWebURL(t *testing.T) {
	t.Run("empty or whitespace", func(t *testing.T) {
		assert.Equal(t, "", NormalizeOneNoteWebURL(""))
		assert.Equal(t, "", NormalizeOneNoteWebURL("   \n\t  "))
	})

	t.Run("non-onedrive url unchanged", func(t *testing.T) {
		nonOneDrive := "https://contoso.sharepoint.com/teams/math/Shared%20Documents/test.one"
		assert.Equal(t, nonOneDrive, NormalizeOneNoteWebURL(nonOneDrive))
	})

	t.Run("already doc.aspx url unchanged", func(t *testing.T) {
		goodURL := "https://onedrive.live.com/personal/1c22e0b2ff1dbe1b/_layouts/15/Doc.aspx?sourcedoc={fcbc70e0-842e-4c9e-9a12-24633fe5f29b}&action=edit&wdorigin=NavigationUrl"
		assert.Equal(t, goodURL, NormalizeOneNoteWebURL(goodURL))
	})

	t.Run("converts legacy redir.aspx with wd parameter", func(t *testing.T) {
		input := "https://onedrive.live.com/redir.aspx?cid=1c22e0b2ff1dbe1b&page=edit&resid=1C22E0B2FF1DBE1B!sfcbc70e0842e4c9e9a1224633fe5f29b&parId=1C22E0B2FF1DBE1B!104&wd=target%28B%C3%A0i%20t%E1%BA%ADp%20kh%E1%BA%AFc%20ph%E1%BB%A5c.one%7C034e413a-5d99-4a96-ab6f-61c324dafa1c%2F%C3%94n%20t%E1%BA%ADp%20ki%E1%BA%BFn%20th%E1%BB%A9c%20gi%E1%BB%AFa%20h%E1%BB%8Dc%20k%E1%BB%B3%20I%20-%20To%C3%A1n%20%7C25685d72-13e3-41ae-9421-9e0dae584a4c%2F%29"

		expected := "https://onedrive.live.com/personal/1c22e0b2ff1dbe1b/_layouts/15/Doc.aspx?sourcedoc={fcbc70e0-842e-4c9e-9a12-24633fe5f29b}&action=edit&wd=target%28B%C3%A0i%20t%E1%BA%ADp%20kh%E1%BA%AFc%20ph%E1%BB%A5c.one%7C034e413a-5d99-4a96-ab6f-61c324dafa1c%2F%C3%94n%20t%E1%BA%ADp%20ki%E1%BA%BFn%20th%E1%BB%A9c%20gi%E1%BB%AFa%20h%E1%BB%8Dc%20k%E1%BB%B3%20I%20-%20To%C3%A1n%20%7C25685d72-13e3-41ae-9421-9e0dae584a4c%2F%29&wdorigin=NavigationUrl"

		actual := NormalizeOneNoteWebURL(input)
		assert.Equal(t, expected, actual)
	})

	t.Run("converts legacy /edit url with id param", func(t *testing.T) {
		input := "https://onedrive.live.com/edit?cid=1c22e0b2ff1dbe1b&id=1C22E0B2FF1DBE1B!sfcbc70e0842e4c9e9a1224633fe5f29b&resid=1C22E0B2FF1DBE1B!sfcbc70e0842e4c9e9a1224633fe5f29b&parId=1C22E0B2FF1DBE1B!104&wd=target(BAT%20PHUONG%20TRINH.one|1234/page|5678/)&wdo=2"

		actual := NormalizeOneNoteWebURL(input)
		expected := "https://onedrive.live.com/personal/1c22e0b2ff1dbe1b/_layouts/15/Doc.aspx?sourcedoc={fcbc70e0-842e-4c9e-9a12-24633fe5f29b}&action=edit&wd=target%28BAT%20PHUONG%20TRINH.one%7C1234%2Fpage%7C5678%2F%29&wdorigin=NavigationUrl"
		assert.Equal(t, expected, actual)
	})
}
