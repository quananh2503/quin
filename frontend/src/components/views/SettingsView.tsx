import React, { useEffect, useState } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { KeyRound, Eye, EyeOff, Save, CheckCircle2, AlertCircle, Cpu } from 'lucide-react';

interface SettingsViewProps {
  showToast: (msg: string, isError?: boolean) => void;
}

export const SettingsView: React.FC<SettingsViewProps> = ({ showToast }) => {
  const [apiKey, setApiKey] = useState('');
  const [showApiKey, setShowApiKey] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  // Nạp API key từ SQLite DB
  const loadKeys = async () => {
    try {
      setLoading(true);
      const keysMap: Record<string, string> = await api.getAPIKeys() || {};
      if (keysMap['deepseek']) {
        setApiKey(keysMap['deepseek']);
      }
    } catch (err) {
      showToast('Lỗi khi tải khóa API: ' + normalizeError(err), true);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadKeys();
  }, []);

  const handleSaveKey = async () => {
    try {
      setSaving(true);
      await api.saveAPIKey('deepseek', apiKey.trim());
      showToast('✅ Đã lưu khóa API AI vào cơ sở dữ liệu!');
    } catch (err) {
      showToast('Lỗi khi lưu khóa API: ' + normalizeError(err), true);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="p-8 max-w-4xl mx-auto space-y-8">
      {/* Header */}
      <div>
        <div className="flex items-center gap-3">
          <div className="p-2.5 bg-emerald-100 text-emerald-700 rounded-xl">
            <KeyRound size={26} />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-800 tracking-tight">Cài đặt Hệ thống</h1>
            <p className="text-sm text-slate-500">Quản lý Khóa API AI và lưu trữ an toàn trong SQLite</p>
          </div>
        </div>
      </div>

      {/* Tabs / Content Section */}
      <div className="space-y-6">
        <div className="border-b border-slate-200 pb-3">
          <h2 className="text-base font-semibold text-slate-800 flex items-center gap-2">
            <span>Cấu hình Trí tuệ Nhân tạo (AI)</span>
            <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full font-normal">
              Lưu trực tiếp trong SQLite DB
            </span>
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Khóa API được lưu cục bộ trên máy tính của bạn, không gửi ra ngoài trừ các yêu cầu chính thức tới dịch vụ AI.
          </p>
        </div>

        {loading ? (
          <div className="py-12 text-center text-slate-400 text-sm">Đang tải cấu hình khóa API...</div>
        ) : (
          <div className="max-w-xl">
            <div className="bg-white rounded-2xl p-6 border border-slate-200/80 shadow-sm flex flex-col justify-between space-y-5 hover:border-slate-300 transition">
              <div className="space-y-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-2.5">
                    <div className="p-2 bg-emerald-50 text-emerald-600 rounded-lg">
                      <Cpu size={20} />
                    </div>
                    <div>
                      <h3 className="font-bold text-slate-800 text-base">Mô hình AI</h3>
                      <span className="text-[11px] text-emerald-700 font-medium bg-emerald-50 px-2 py-0.5 rounded">
                        Tự động hóa biên soạn • Tối ưu hiệu năng
                      </span>
                    </div>
                  </div>
                  {apiKey.trim() ? (
                    <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-emerald-600 bg-emerald-50 px-2.5 py-1 rounded-full">
                      <CheckCircle2 size={13} /> Đã cấu hình
                    </span>
                  ) : (
                    <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-amber-600 bg-amber-50 px-2.5 py-1 rounded-full">
                      <AlertCircle size={13} /> Chưa có key
                    </span>
                  )}
                </div>

                <p className="text-xs text-slate-500 leading-relaxed">
                  Kích hoạt hệ thống AI chuyên sâu: tự động bóc tách tài liệu bài giảng, phân loại dạng toán, nhúng mẹo giải nhanh Casio, biên soạn các bước giải chi tiết và tự động chuẩn hóa định dạng.
                </p>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Khóa API (API Key)
                  </label>
                  <div className="relative">
                    <input
                      type={showApiKey ? 'text' : 'password'}
                      value={apiKey}
                      onChange={(e) => setApiKey(e.target.value)}
                      placeholder="sk-..."
                      className="w-full text-xs font-mono px-3 py-2.5 pr-10 rounded-lg border border-slate-200 bg-slate-50/50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition"
                    />
                    <button
                      type="button"
                      onClick={() => setShowApiKey(!showApiKey)}
                      className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 p-1 cursor-pointer"
                    >
                      {showApiKey ? <EyeOff size={15} /> : <Eye size={15} />}
                    </button>
                  </div>
                </div>
              </div>

              <div className="pt-3 border-t border-slate-100 flex justify-end">
                <button
                  onClick={handleSaveKey}
                  disabled={saving}
                  className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 active:scale-95 text-white text-xs font-semibold rounded-lg shadow-sm transition disabled:opacity-50 cursor-pointer"
                >
                  <Save size={14} />
                  {saving ? 'Đang lưu...' : 'Lưu Khóa API'}
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
