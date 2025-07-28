import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';
import { spawn } from 'child_process';
import readline from 'readline';

// Create readline interface for user input
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

async function connectToMCPServer() {
  console.log(' Starting MCP Client Demo\n');
  
  // Path to your MCP server
  const serverPath = '../SecurityAI/mcp-mssql-server/main.py';
  
  // Create transport using stdio
  const transport = new StdioClientTransport({
    command: 'python',
    args: [serverPath],
    env: { ...process.env }
  });

  // Create client
  const client = new Client({
    name: 'mcp-client-demo',
    version: '1.0.0'
  }, {
    capabilities: {}
  });

  try {
    // Connect to server
    await client.connect(transport);
    console.log(' Connected to MCP server\n');

    // List available tools
    const tools = await client.listTools();
    console.log(` Found ${tools.tools.length} tools:\n`);

    // Display tools with formatting
    tools.tools.forEach((tool, index) => {
      console.log(`${index + 1}. ${tool.name}`);
      console.log(`    ${tool.description || 'No description'}`);
      
      if (tool.inputSchema?.properties) {
        console.log('   Parameters:');
        Object.entries(tool.inputSchema.properties).forEach(([param, schema]) => {
          const required = tool.inputSchema.required?.includes(param) ? '(required)' : '(optional)';
          console.log(`     - ${param}: ${schema.type} ${required}`);
          if (schema.description) {
            console.log(`       ${schema.description}`);
          }
        });
      }
      console.log('');
    });

    // Interactive tool invocation
    await interactiveMode(client, tools.tools);

  } catch (error) {
    console.error(' Error:', error.message);
  } finally {
    await transport.close();
    rl.close();
  }
}

async function interactiveMode(client, tools) {
  while (true) {
    const toolIndex = await question('\n🔧 Enter tool number to invoke (or "exit" to quit): ');
    
    if (toolIndex.toLowerCase() === 'exit') {
      console.log('👋 Goodbye!');
      break;
    }

    const index = parseInt(toolIndex) - 1;
    if (index < 0 || index >= tools.length) {
      console.log('Invalid tool number');
      continue;
    }

    const tool = tools[index];
    console.log(`\n Invoking: ${tool.name}`);

    // Collect parameters
    const args = {};
    if (tool.inputSchema?.properties) {
      for (const [param, schema] of Object.entries(tool.inputSchema.properties)) {
        const required = tool.inputSchema.required?.includes(param);
        const prompt = required 
          ? `Enter ${param} (${schema.type}): `
          : `Enter ${param} (${schema.type}, optional - press Enter to skip): `;
        
        const value = await question(prompt);
        if (value.trim()) {
          args[param] = value;
        }
      }
    }

    try {
      console.log('\n⏳ Calling tool...');
      const result = await client.callTool(tool.name, args);
      console.log('\n Result:');
      console.log(JSON.stringify(result.content, null, 2));
    } catch (error) {
      console.error('\n Error calling tool:', error.message);
    }
  }
}

function question(prompt) {
  return new Promise(resolve => {
    rl.question(prompt, resolve);
  });
}

// Run the client
connectToMCPServer().catch(console.error);
