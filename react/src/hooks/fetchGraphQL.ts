// your-app-name/src/fetchGraphQL.js
async function fetchGraphQL(text, variables) {
  const response = await fetch('http://localhost:3000/graphql', {
    method: 'POST',
    headers: {
      // Authorization: `bearer ${REACT_APP_GITHUB_AUTH_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: text,
      variables,
    }),
  });

  // Get the response as JSON
  return await response.json();
}

export default fetchGraphQL;