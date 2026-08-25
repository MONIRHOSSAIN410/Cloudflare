import { describe, it, expect } from 'vitest';

describe('Chatbot System APIs', () => {
  const API_KEY = "my_secret_token";
  const BASE_URL = "http://localhost:8787";

  it('rejects unauthorized bot creation', async () => {
    const res = await fetch(`${BASE_URL}/api/bots`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Test', systemPrompt: 'Hi', monthlyLimit: 100 })
    });
    expect(res.status).toBe(401);
  });

  it('handles invalid endpoint gracefully', async () => {
    const res = await fetch(`${BASE_URL}/api/unknown`, {
      headers: { 'Authorization': `Bearer ${API_KEY}` }
    });
    expect(res.status).toBe(404);
  });
});