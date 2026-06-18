import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Sparkles, Send, Bot, User, Trash2, ArrowDown } from 'lucide-react';
import api from '../api';

const suggestions = [
  "ورّيني كل الفنادق والأوض بتاعتهم",
  "فيه أوضة متاحة في فندق X من 10 يونيو لـ 15 يونيو؟",
  "ورّيني الحجوزات اللي pending",
  "ايه أرخص أوضة عندنا دلوقتي؟",
  "الأنشطة والتورز المتاحة إيه؟",
  "احجزلي أوضة لـ أحمد علي",
];

export default function AiAssistant() {
  const [messages, setMessages] = useState([
    {
      role: 'assistant',
      content: "أهلاً! أنا **كونسيرج الغردقة** 🌴 — المساعد الذكي بتاعك في لوحة التحكم.\n\nبقدر أساعدك في كل حاجة:\n- 🏨 **الفنادق والأوض** — تفاصيل وأسعار\n- 📅 **التوافر** — أتحقق من أي أوضة في أي تواريخ\n- 📋 **الحجوزات** — تشوفها وتعدل عليها\n- ✅ **تأكيد أو إلغاء** حجز\n- ➕ **إنشاء حجز جديد**\n\nقولي إيه اللي عايزه بالعامية أو الإنجليزي وأنا هجيبهولك! 😊"
    }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  const messagesEndRef = useRef(null);
  const chatContainerRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, loading]);

  const handleClear = () => {
    if (window.confirm("Are you sure you want to clear this conversation?")) {
      setMessages([
        {
          role: 'assistant',
          content: "أهلاً! أنا **كونسيرج الغردقة** 🌴 — المساعد الذكي بتاعك في لوحة التحكم.\n\nبقدر أساعدك في كل حاجة:\n- 🏨 **الفنادق والأوض** — تفاصيل وأسعار\n- 📅 **التوافر** — أتحقق من أي أوضة في أي تواريخ\n- 📋 **الحجوزات** — تشوفها وتعدل عليها\n- ✅ **تأكيد أو إلغاء** حجز\n- ➕ **إنشاء حجز جديد**\n\nقولي إيه اللي عايزه بالعامية أو الإنجليزي وأنا هجيبهولك! 😊"
        }
      ]);
      setError(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const query = input.trim();
    if (!query) return;

    await sendMessage(query);
  };

  const handleSuggestionClick = async (suggestion) => {
    await sendMessage(suggestion);
  };

  const sendMessage = async (textText) => {
    const updatedMessages = [...messages, { role: 'user', content: textText }];
    setMessages(updatedMessages);
    setInput('');
    setLoading(true);
    setError(null);

    try {
      // Send the entire conversation history to backend route /ai/chat
      const res = await api.post('/ai/chat', { messages: updatedMessages });
      
      if (res.data && res.data.response) {
        setMessages(prev => [...prev, { role: 'assistant', content: res.data.response }]);
      } else {
        throw new Error('Invalid response payload from server.');
      }
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || err.message || "Something went wrong while connecting to the AI service.";
      setError(errMsg);
    } finally {
      setLoading(false);
    }
  };

  // Advanced inline and block formatter for AI Markdown responses
  const renderMessageContent = (text) => {
    if (!text) return null;

    const lines = text.split('\n');
    const elements = [];
    let tableRows = [];
    let inTable = false;
    let tableHeaders = [];
    let listItems = [];
    let inList = false;

    const flushList = (key) => {
      if (listItems.length > 0) {
        elements.push(
          <ul key={`list-${key}`} className="list-disc pl-5 mb-3 space-y-1 text-sm text-gray-700 leading-relaxed">
            {listItems.map((item, idx) => <li key={idx}>{item}</li>)}
          </ul>
        );
        listItems = [];
        inList = false;
      }
    };

    const flushTable = (key) => {
      if (tableRows.length > 0) {
        elements.push(
          <div key={`table-wrapper-${key}`} className="overflow-x-auto my-3 border border-gray-200 rounded-xl shadow-sm">
            <table className="min-w-full divide-y divide-gray-200 text-sm">
              <thead className="bg-gray-50/70 backdrop-blur-sm">
                <tr>
                  {tableHeaders.map((h, idx) => (
                    <th key={idx} className="px-4 py-2.5 text-left font-bold text-gray-800 border-b border-gray-200 tracking-wide">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {tableRows.map((row, rIdx) => (
                  <tr key={rIdx} className={rIdx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    {row.map((cell, cIdx) => (
                      <td key={cIdx} className="px-4 py-2.5 text-gray-600 font-medium">{cell}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        );
        tableRows = [];
        tableHeaders = [];
        inTable = false;
      }
    };

    const parseInlineMarkdown = (str) => {
      const parts = [];
      let lastIdx = 0;
      const regex = /\*\*(.*?)\*\*/g;
      let match;
      while ((match = regex.exec(str)) !== null) {
        if (match.index > lastIdx) {
          parts.push(str.substring(lastIdx, match.index));
        }
        parts.push(<strong key={match.index} className="font-bold text-gray-900 bg-blue-50 px-1 rounded">{match[1]}</strong>);
        lastIdx = regex.lastIndex;
      }
      if (lastIdx < str.length) {
        parts.push(str.substring(lastIdx));
      }
      return parts.length > 0 ? parts : str;
    };

    lines.forEach((line, lineIdx) => {
      const trimmed = line.trim();

      // Table detection
      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        flushList(lineIdx);
        const cells = trimmed.split('|').map(c => c.trim()).filter((_, idx, arr) => idx > 0 && idx < arr.length - 1);
        const isSeparator = cells.every(c => c.startsWith('-') || c === '');
        if (isSeparator) return;

        if (!inTable) {
          inTable = true;
          tableHeaders = cells.map(c => parseInlineMarkdown(c));
        } else {
          tableRows.push(cells.map(c => parseInlineMarkdown(c)));
        }
        return;
      } else if (inTable) {
        flushTable(lineIdx);
      }

      // Unordered lists
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        flushTable(lineIdx);
        inList = true;
        listItems.push(parseInlineMarkdown(trimmed.substring(2)));
        return;
      } else if (inList) {
        flushList(lineIdx);
      }

      // Headings
      if (trimmed.startsWith('### ')) {
        elements.push(<h4 key={lineIdx} className="text-base font-bold text-gray-800 mt-4 mb-2 flex items-center gap-1.5">{parseInlineMarkdown(trimmed.substring(4))}</h4>);
        return;
      } else if (trimmed.startsWith('## ')) {
        elements.push(<h3 key={lineIdx} className="text-lg font-extrabold text-gray-950 mt-5 mb-2 border-b border-gray-100 pb-1">{parseInlineMarkdown(trimmed.substring(3))}</h3>);
        return;
      } else if (trimmed.startsWith('# ')) {
        elements.push(<h2 key={lineIdx} className="text-xl font-black text-gray-950 mt-6 mb-3">{parseInlineMarkdown(trimmed.substring(2))}</h2>);
        return;
      }

      // Paragraph / Empty lines
      if (trimmed === '') {
        elements.push(<div key={lineIdx} className="h-2" />);
      } else {
        elements.push(<p key={lineIdx} className="text-sm leading-relaxed text-gray-700 mb-2">{parseInlineMarkdown(line)}</p>);
      }
    });

    // Final flushes
    flushList('final');
    flushTable('final');

    return elements;
  };

  return (
    <div className="flex flex-col h-[calc(100vh-80px)] lg:h-[calc(100vh-40px)] bg-gray-50/50 rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
      {/* Header */}
      <div className="px-6 py-4 bg-white border-b border-gray-100 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center text-white shadow-md shadow-blue-500/10">
            <Sparkles className="w-5 h-5 animate-pulse" />
          </div>
          <div>
            <h2 className="text-base font-bold text-gray-900 flex items-center gap-2">
              Hurghada Concierge
              <span className="text-[10px] font-semibold bg-emerald-50 text-emerald-600 border border-emerald-100 px-1.5 py-0.5 rounded-full uppercase tracking-wider">Live DB Access</span>
            </h2>
            <p className="text-xs text-gray-400 font-medium">مساعدك الذكي للإدارة — بيفهم عربي وإنجليزي</p>
          </div>
        </div>
        <button
          onClick={handleClear}
          className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all duration-200"
          title="Clear Conversation"
        >
          <Trash2 className="w-4.5 h-4.5" />
        </button>
      </div>

      {/* Main Chat Area */}
      <div 
        ref={chatContainerRef}
        className="flex-1 overflow-y-auto p-6 space-y-4"
      >
        <AnimatePresence initial={false}>
          {messages.map((msg, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.25 }}
              className={`flex gap-4.5 max-w-[85%] ${msg.role === 'user' ? 'ml-auto flex-row-reverse' : 'mr-auto'}`}
            >
              {/* Avatar */}
              <div className={`w-8.5 h-8.5 rounded-xl flex items-center justify-center flex-shrink-0 shadow-sm ${
                msg.role === 'user'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-blue-600 border border-gray-100'
              }`}>
                {msg.role === 'user' ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
              </div>

              {/* Message Bubble */}
              <div className={`px-4.5 py-3 rounded-2xl text-sm ${
                msg.role === 'user'
                  ? 'bg-blue-600 text-white rounded-tr-none'
                  : 'bg-white text-gray-800 border border-gray-100 rounded-tl-none shadow-sm shadow-gray-100/50'
              }`}>
                {msg.role === 'user' ? (
                  <p className="leading-relaxed font-medium">{msg.content}</p>
                ) : (
                  <div className="space-y-0.5">
                    {renderMessageContent(msg.content)}
                  </div>
                )}
              </div>
            </motion.div>
          ))}

          {/* Typing Indicator */}
          {loading && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="flex gap-4.5 max-w-[80%] mr-auto"
            >
              <div className="w-8.5 h-8.5 rounded-xl bg-white text-blue-600 border border-gray-100 flex items-center justify-center shadow-sm">
                <Bot className="w-4 h-4 animate-spin-slow" />
              </div>
              <div className="px-4.5 py-3 rounded-2xl rounded-tl-none bg-white border border-gray-100 shadow-sm">
                <div className="flex items-center gap-2 mb-1.5">
                  <span className="text-[10px] font-bold text-blue-500 uppercase tracking-wider">بيفكر ويجيب البيانات...</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '0ms' }} />
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '150ms' }} />
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '300ms' }} />
                </div>
              </div>
            </motion.div>
          )}

          {/* Error Message */}
          {error && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="p-4 bg-red-50 border border-red-100 rounded-xl text-red-700 text-xs font-semibold max-w-[85%] mx-auto text-center"
            >
              ⚠️ Error: {error}
            </motion.div>
          )}
        </AnimatePresence>
        <div ref={messagesEndRef} />
      </div>

      {/* Suggested Questions & Input Area */}
      <div className="p-6 bg-white border-t border-gray-100">
        {/* Suggestion Chips */}
        {messages.length === 1 && !loading && (
          <div className="mb-4">
            <p className="text-xs text-gray-400 font-semibold mb-2.5 uppercase tracking-wide">جرّب تسأل</p>
            <div className="flex flex-wrap gap-2">
              {suggestions.map((suggestion, idx) => (
                <button
                  key={idx}
                  onClick={() => handleSuggestionClick(suggestion)}
                  className="px-3.5 py-2 text-xs font-medium text-blue-600 bg-blue-50/50 hover:bg-blue-50 border border-blue-100/50 rounded-xl transition-all duration-200 text-left"
                >
                  {suggestion}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Input Form */}
        <form onSubmit={handleSubmit} className="flex gap-3">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            disabled={loading}
            placeholder="اسأل بالعامية أو الإنجليزي... مثلاً: احجزلي أوضة، ورّيني الحجوزات"
            className="flex-1 px-4.5 py-3 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium disabled:opacity-50 disabled:bg-gray-100"
          />
          <button
            type="submit"
            disabled={loading || !input.trim()}
            className="px-5 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold flex items-center justify-center gap-2 transition-all duration-200 shadow-md shadow-blue-500/10 disabled:opacity-50 disabled:shadow-none disabled:hover:bg-blue-600"
          >
            <span>Send</span>
            <Send className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
}
