package skip

import (
	"strings"

	"github.com/martin-helmich/prometheus-nginxlog-exporter/config"
	"github.com/satyrius/gonx"
)

// Skip determines if a log entry should be skipped based on the given skip configurations
func Skip(configs []config.SkipConfig, fields gonx.Fields) bool {
	if len(configs) == 0 {
		return false
	}

	for _, config := range configs {
		doSkip := skip(&config, fields)
		if doSkip {
			return true
		}
	}

	return false
}

func skip(skip *config.SkipConfig, fields gonx.Fields) bool {
	field := skip.FieldName
	split := skip.Split
	if field == "" {
		// default to request URI
		field = "request"
		if split == 0 {
			split = 2
		}
	}
	str, ok := fields[field]

	if split > 0 {
		values := strings.Split(str, " ")

		if len(values) >= split {
			str = values[split-1]
		} else {
			str = ""
		}
	}

	if !ok {
		return false
	}
	return skip.CompiledRegexp.MatchString(str)
}
