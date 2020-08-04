package config

import (
	"fmt"
	"regexp"
)

// SkipConfig is a struct the configuration for skipping a parsed line in
// the source based on matching a regex on a specific field
type SkipConfig struct {
	FieldName    string `hcl:"from,attr" yaml:"from"`
	RegexpString string `hcl:"match,attr" yaml:"match"`
	Split        int    `hcl:"split,attr"`
	Negate       bool   `hcl:"negate,attr"`

	CompiledRegexp *regexp.Regexp
}

// Compile compiles expressions for efficient later use
func (c *SkipConfig) Compile() error {
	r, err := regexp.Compile(c.RegexpString)
	if err != nil {
		return fmt.Errorf("could not compile regexp '%s': %s", c.RegexpString, err.Error())
	}

	c.CompiledRegexp = r

	return nil
}
