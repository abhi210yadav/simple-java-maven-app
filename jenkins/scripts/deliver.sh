#!/usr/bin/env bash
set -e

echo '🔧 Installing Maven-built Java application into local repository...'
mvn -B -q clean install -DskipTests

echo '🔍 Extracting clean project name and version from pom.xml...'
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | grep -Ev '(^\\[|Download|WARN|INFO)' | tr -d '\r' | xargs)
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | grep -Ev '(^\\[|Download|WARN|INFO)' | tr -d '\r' | xargs)

echo "✅ Project name: [$NAME]"
echo "✅ Project version: [$VERSION]"

JAR_FILE="target/${NAME}-${VERSION}.jar"
echo "📦 Checking for: $JAR_FILE"

# Double-check existence with find (ANSI-agnostic)
if [ ! -f "$JAR_FILE" ]; then
  echo "⚠️ Exact path not matching — trying dynamic search..."
  JAR_FILE=$(find target -maxdepth 1 -type f -name "*.jar" | head -n 1 || true)
fi

if [ -z "$JAR_FILE" ]; then
  echo "❌ ERROR: Still no jar found!"
  echo "Listing target directory for debugging:"
  ls -la target
  exit 1
fi

echo "✅ Using JAR file: $JAR_FILE"
echo "🚀 Running Java application..."
java -jar "$JAR_FILE"
echo "🎉 Delivery successful!"
