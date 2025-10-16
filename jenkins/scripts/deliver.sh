#!/usr/bin/env bash
set -e

echo '🔧 Installing Maven-built Java application into local repository...'
mvn -B -q clean install -DskipTests

echo '🔍 Extracting project name and version from pom.xml...'
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | grep -Ev '(^\[|Download|WARN)')
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download|WARN)')

if [ -z "$NAME" ] || [ -z "$VERSION" ]; then
  echo "❌ ERROR: Failed to read project name or version from pom.xml!"
  exit 1
fi

echo "✅ Project name: $NAME"
echo "✅ Project version: $VERSION"

JAR_FILE="target/${NAME}-${VERSION}.jar"

echo "📦 Checking if jar exists: $JAR_FILE"
if [ ! -f "$JAR_FILE" ]; then
  echo "❌ ERROR: JAR file not found! Listing target directory..."
  ls -la target
  exit 1
fi

echo "🚀 Running Java application..."
java -jar "$JAR_FILE"

echo "🎉 Delivery successful!"
